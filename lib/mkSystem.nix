{
  inputs,
  lib,
}: {host}: let
  specialArgs = {inherit inputs host;};
  inherit (host) backend;
  modules = import ../config/recipe-assembly.nix {inherit inputs host backend;};
in {
  nixosConfigurations = lib.optionalAttrs (host.backend == "nixos") {
    "${host.name}" = inputs.nixpkgs.lib.nixosSystem {
      inherit specialArgs modules;
      system = host.platform;
    };
  };
  darwinConfigurations = lib.optionalAttrs (host.backend == "darwin") {
    "${host.name}" = inputs.nix-darwin.lib.darwinSystem {
      inherit specialArgs modules;
    };
  };
}
