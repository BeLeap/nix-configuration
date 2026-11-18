# Configure Telescope layout and path display

- Updated the Nixvim Telescope defaults to use the vertical layout strategy and smart path display.
- Kept the configuration in Nix; no Lua configuration was added.
- Validation: could not run a Nix syntax check because `nix-instantiate`, `nix`, and `nix-shell` are unavailable in the environment. Reviewed the source diff instead.
