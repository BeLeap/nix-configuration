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
