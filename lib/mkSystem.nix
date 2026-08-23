{
  inputs,
  lib,
}: {host}: let
  specialArgs = {inherit inputs host;};
  modules = import ../config/recipe-assembly.nix {inherit inputs host;};
in {
  nixosConfigurations = lib.optionalAttrs (host.distribution == "nixos") {
    "${host.name}" = inputs.nixpkgs.lib.nixosSystem {
      inherit specialArgs modules;
      system = host.platform;
    };
  };
  darwinConfigurations = lib.optionalAttrs (host.distribution == "macos") {
    "${host.name}" = inputs.nix-darwin.lib.darwinSystem {
      inherit specialArgs modules;
    };
  };
}
