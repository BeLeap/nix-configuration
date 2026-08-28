# Switch to Monoplex KR Nerd Font

- Replaced the shared development font package `nerd-fonts.caskaydia-cove` with `monoplex-kr-nerd` from the BeLeap overlay.
- Updated Rofi to `Monoplex KR Nerd 14`.
- Updated WezTerm's pane and tab-bar font selection to `Monoplex KR Nerd`.
- Verified the overlay package builds as version `0.0.2`; `fc-scan` reports the family name `Monoplex KR Nerd`.
- Ran `nix fmt .`; Alejandra reported the repository is formatted.
- Darwin system evaluation passed. NixOS evaluation passed with `NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1`; a normal NixOS evaluation remains blocked by the pre-existing Darwin-only `poke-token-bar` package in the Linux VM configuration.
- No old Cascadia/Caskaydia references remain in `config/`; historical journal entries retain their original records.
