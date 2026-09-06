# Reset ZeroClaw Discord slash commands

## Findings

- The live bot is `미기`; its Discord application currently has 100 global application commands and 0 guild-specific commands.
- The global commands are the previous Hermes Agent/skill set (`compress`, `title`, `hermes-agent`, `joplin`, `new`, `status`, etc.), not commands registered by the live ZeroClaw process.
- The running Nix-managed ZeroClaw is version 0.7.5. Its Discord implementation does not support native application-command registration, and the generated config has no `slash_commands` option.
- No Discord command was deleted or changed because deleting now would leave the bot with no slash commands and the installed ZeroClaw could not re-register them.

## Next decision

Upgrade ZeroClaw to a release with Discord slash-command support (0.8+) and enable its Discord slash-command setting before replacing the global command set. The repository's pinned nixpkgs currently evaluates `pkgs.zeroclaw` as 0.7.5.

## Follow-up

- Replaced the bot application's 100 global application commands with an empty command set through Discord's bulk-overwrite endpoint.
- Replaced the command set for the bot's one connected guild with an empty list as well.
- Verification passed: 0 global commands and 0 guild commands remain.
- ZeroClaw 0.7.5 was left running; it does not re-register Discord slash commands.

## 2026-09-07 — Use unstable ZeroClaw

- Switched the Mac mini recipe's runtime binary and Home Manager package from the stable `zeroclaw` attribute to `pkgs.unstable.zeroclaw` / `unstable.zeroclaw`.
- The locked unstable input evaluates to ZeroClaw 0.8.3; the Darwin system build fetched `zeroclaw-0.8.3` successfully.
- Removed the stale 0.7.5 version reference from the token-rendering comment while preserving private runtime configuration.

## Validation

- `nix-instantiate --parse config/recipe/beleap-macmini/default.nix` passed.
- Alejandra and Statix checks passed for the modified recipe.
- `darwinConfigurations.beleap-macmini.system` evaluated and built successfully.
- `nix flake check --accept-flake-config` remains blocked by the existing VM configuration evaluating Darwin-only `poke-token-bar` on `aarch64-linux`.

## 2026-09-07 — Load Pi delegation from the v3 agent workspace

- ZeroClaw 0.8.3 ignored the legacy skill location under `~/.zeroclaw/workspace/skills`; `zeroclaw skills list --agent default` reported no skills even though the TOML passed `skills audit`.
- The supported v3 per-agent location is `~/.zeroclaw/agents/default/workspace/skills/pi_delegate/SKILL.toml`. The recipe now writes the skill there and stages delegation state under the matching agent workspace.
- ZeroClaw namespaces skill tools with `__`; the recipe now uses `pi_delegate__status`, `pi_delegate__start`, and `pi_delegate__cancel` in the approval policy and skill instructions.
- Direct validation loaded one skill with three tools. `pi_delegate__status` ran without an approval prompt and returned `No Pi delegation is waiting.` The start path was not invoked because no user-approved delegation task was provided.
- The live LaunchAgent is running ZeroClaw 0.8.3 from the new generated daemon, the Discord peer group authorizes `540435382853173280`, Discord channel doctor reports healthy, and the runtime trace records the skill as registered plus Discord READY.

## Validation

- `nix-instantiate --parse`, Alejandra, Statix, Darwin evaluation, and the Darwin system build passed after the workspace/tool-name changes.
- Generated config assertions passed for schema v3, the Discord peer group, native tools, disabled reasoning replay, context size, and delegation approval lists.
- No new Qwen/Ollama `EOF` appears in the runtime trace after the current configuration loaded; direct ZeroClaw status-tool calls completed successfully.
- Token rotation is still a manual follow-up in the Discord Developer Portal; the bot token was not read or copied into repository files.

## Follow-up

- Updated the runner's status instructions to use ZeroClaw's actual `pi_delegate__status` name so the model does not receive a stale dotted tool name after starting a run.
- Rebuilt the Darwin system and audited the latest generated skill; both passed. The active LaunchAgent remains healthy on the prior equivalent generated daemon until activation is run.
- `sudo -n darwin-rebuild switch --flake .#beleap-macmini` was blocked because a password is required. Run the activation interactively to install the latest generated runner.
