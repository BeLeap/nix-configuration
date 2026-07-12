# VM DHCP DNS

- Requested change: stop pinning DNS servers in the NixOS VM recipe and use DHCP-provided DNS instead.
- Updated `config/recipe/nixos/vm/default.nix` to remove the hard-coded `networking.nameservers` block.
- Intention: allow the VM networking stack to inherit DNS servers from DHCP rather than forcing public resolvers.
