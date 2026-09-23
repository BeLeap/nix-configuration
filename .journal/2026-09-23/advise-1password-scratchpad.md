# Advise on 1Password and AeroSpace scratchpad

## Observation

- The current AeroSpace scratchpad target is `com.1password.1password` / `1Password`.
- The user reports that after waking the Mac, AeroSpace's scratchpad keyboard shortcut can stop responding while 1Password is using secure input.
- Current SSH configuration resolves `IdentityAgent` to the 1Password macOS agent socket, but a live `ssh-add -l` check currently reports `The agent has no identities`.

## Assessment

- Secure input is the likely mechanism blocking AeroSpace's global keyboard event handling; this is a structural conflict, not a scratchpad matching problem.
- Recommended design: do not put 1Password in the keyboard-controlled scratchpad. Use the 1Password SSH agent for normal `ssh` commands, keep 1Password accessible from its menu-bar/Quick Access UI, and use a dedicated terminal scratchpad for SSH if desired.
- Do not disable secure input. If the shortcut is already stuck, unlock or quit/reopen 1Password as a recovery test, then check for the AeroSpace secure-input indicator.

## Sources and validation

- Context7: `/nikitabobko/aerospace` documents app-to-workspace rules and key bindings.
- Context7: `/websites/1password_dev_cli` documents SSH-key CLI access, but did not return the desktop SSH-agent setup page.
- Apple/1Password/AeroSpace web results support the secure-input explanation and 1Password SSH-agent/Touch ID settings.

## Configuration change

- Removed the 1Password entry from `config/recipe/aerospace/app-assignments.nix`, leaving `scratchpad-apps` empty.
- Added shell no-ops to the empty scratchpad toggle branches so the generated script remains valid and reports the explicit no-target error instead of failing Bash syntax validation.
- Nix evaluation confirmed the generated `on-window-detected` rules contain no 1Password rule.
- Full Darwin builds and `nh darwin switch --no-nom` were attempted but exceeded the execution time limit while compiling/fetching unrelated dependencies; the live AeroSpace symlink has not been confirmed as updated.
