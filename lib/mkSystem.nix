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
  homeConfigurations = lib.optionalAttrs (host.backend == "home-manager") {
    "${host.name}" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        system = host.platform;
        config.allowUnfree = true;
      };
      extraSpecialArgs = specialArgs;
      inherit modules;
    };
  };
}
