{
  inputs,
  lib,
}: hosts: let
  mkSystem = import ./mkSystem.nix {inherit inputs lib;};
in
  lib.foldr
  (host: acc: let
    system = mkSystem {inherit host;};
    systemConfiguration =
      if host.backend == "nixos"
      then system.nixosConfigurations.${host.name}
      else system.darwinConfigurations.${host.name};
    homeManager =
      if host.backend == "nixos"
      then inputs.home-manager
      else inputs.home-manager-darwin;
    homeModules = import ../config/recipe-modules.nix {
      inherit inputs host;
      backend = host.backend;
    };
  in {
    nixosConfigurations = acc.nixosConfigurations // system.nixosConfigurations;
    darwinConfigurations = acc.darwinConfigurations // system.darwinConfigurations;
    homeConfigurations =
      acc.homeConfigurations
      // {
        "${host.usernameLower}@${host.name}" = homeManager.lib.homeManagerConfiguration {
          pkgs = systemConfiguration.pkgs;
          extraSpecialArgs = {inherit inputs host;};
          modules = homeModules.home;
        };
      };
  })
  {
    nixosConfigurations = {};
    darwinConfigurations = {};
    homeConfigurations = {};
  }
  hosts
