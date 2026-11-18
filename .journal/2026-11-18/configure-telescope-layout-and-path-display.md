# Configure Telescope layout and path display

- Updated the Nixvim Telescope defaults to use the vertical layout strategy and smart path display.
- Kept the configuration in Nix; no Lua configuration was added.
- Validation: could not run a Nix syntax check because `nix-instantiate`, `nix`, and `nix-shell` are unavailable in the environment. Reviewed the source diff instead.
- Follow-up: replaced `smart` path display with the requested `shorten` configuration and `truncate` entry; represent the array item in Nixvim as `__unkeyed-1`.
