name=$1

nix build ".#nixosConfigurations.$name.config.system.build.qcow2"
