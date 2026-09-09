#!/bin/sh
set -eu
umask 077

COREUTILS=@coreutilsBin@
CONFIG_FILE=@configFile@
CONFIG_SOURCE=@configSource@
DISCORD_TOKEN_FILE=@discordTokenFile@
ENVSUBST=@envsubst@
PI_DELEGATE_SKILL=@piDelegateSkill@
AGENT_BROWSER_SKILL=@agentBrowserSkill@
PROJECT_ROOT=@projectRoot@
AGENT_WORKSPACE=@agentWorkspace@
DELEGATE_STATE_DIR=@delegateStateDir@
SKILL_FILE="$AGENT_WORKSPACE/skills/pi_delegate/SKILL.toml"
BROWSER_SKILL_FILE="$AGENT_WORKSPACE/skills/agent-browser/SKILL.md"

"$COREUTILS/mkdir" -p "$PROJECT_ROOT" "$AGENT_WORKSPACE/skills/pi_delegate" "$AGENT_WORKSPACE/skills/agent-browser" "$DELEGATE_STATE_DIR"
if [ -L "$SKILL_FILE" ]; then
  echo "Refusing to replace symlinked ZeroClaw skill: $SKILL_FILE" >&2
  exit 1
fi
"$COREUTILS/cp" -f "$PI_DELEGATE_SKILL" "$SKILL_FILE"
"$COREUTILS/chmod" 600 "$SKILL_FILE"

if [ -L "$BROWSER_SKILL_FILE" ]; then
  echo "Refusing to replace symlinked agent-browser skill: $BROWSER_SKILL_FILE" >&2
  exit 1
fi
"$COREUTILS/cp" -f "$AGENT_BROWSER_SKILL" "$BROWSER_SKILL_FILE"
"$COREUTILS/chmod" 600 "$BROWSER_SKILL_FILE"

if [ ! -s "$DISCORD_TOKEN_FILE" ]; then
  echo "Waiting for Discord bot token at $DISCORD_TOKEN_FILE" >&2
fi
while [ ! -s "$DISCORD_TOKEN_FILE" ]; do
  "$COREUTILS/sleep" 5
done

discord_token=$("$COREUTILS/cat" "$DISCORD_TOKEN_FILE")
if [ -z "$discord_token" ]; then
  echo "Discord bot token file is empty" >&2
  exit 1
fi
export ZEROCLAW_DISCORD_BOT_TOKEN="$discord_token"

# Render the external token into a private runtime config instead of the Nix store.
tmp_config="$CONFIG_FILE.tmp.$$"
# Pass a literal variable name so envsubst only renders the Discord token.
# shellcheck disable=SC2016
"$ENVSUBST" '$ZEROCLAW_DISCORD_BOT_TOKEN' < "$CONFIG_SOURCE" > "$tmp_config"
"$COREUTILS/chmod" 600 "$tmp_config"
"$COREUTILS/mv" -f "$tmp_config" "$CONFIG_FILE"
unset ZEROCLAW_DISCORD_BOT_TOKEN

exec @zeroclawBin@ daemon
