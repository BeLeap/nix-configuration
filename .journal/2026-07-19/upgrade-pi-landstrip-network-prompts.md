# Upgrade pi-landstrip for proxy-level network approval prompts

Updated the declarative Pi package pin from `pi-landstrip` 0.16.26 to 0.17.7, the earliest release with proxy-level domain approval prompts. The older release only prompted for domains recognized in the shell command text and returned a proxy denial for requests such as `curl example.com`; 0.17.7 asks for approval when its proxy observes an unapproved HTTP or HTTPS destination, while retaining deny-by-default behavior with `network.allowNetwork: false` and an empty `allowedDomains` list.

Validated from the upstream tag history that 0.17.7 is the first supporting release and that it supports Pi 0.80.6. `alejandra --check config/recipe/pi/default.nix` passed, and the focused Jujutsu diff contains only the package-version update.

Apply the Home Manager configuration and restart Pi before testing. Session-only grants are cleared on restart; persistent project/global grants remain in their respective `sandbox.json` files.
