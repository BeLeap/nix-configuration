name=$1

nix run ".#nixosConfigurations.$name.config.system.build.vm"
