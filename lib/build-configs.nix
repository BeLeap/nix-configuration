{
  inputs,
  lib,
}: hosts: let
  mkSystem = import ./mkSystem.nix {inherit inputs lib;};
  overlays = import ../config/recipe/overlay/overlays.nix;
in
  lib.foldr
  (host: acc: let
    isHomeManagerOnly = host.backend == "home-manager";
    isDarwin = lib.hasSuffix "-darwin" host.platform;
    system =
      if isHomeManagerOnly
      then {
        nixosConfigurations = {};
        darwinConfigurations = {};
      }
      else mkSystem {inherit host;};
    systemConfiguration =
      if host.backend == "nixos"
      then system.nixosConfigurations.${host.name}
      else if host.backend == "darwin"
      then system.darwinConfigurations.${host.name}
      else null;
    homeManager =
      if isDarwin
      then inputs.home-manager-darwin
      else inputs.home-manager;
    pkgs =
      if isHomeManagerOnly
      then
        import
        (
          if isDarwin
          then inputs.nixpkgs-darwin
          else inputs.nixpkgs
        )
        {
          system = host.platform;
          config = import ./nixpkgs-config.nix;
          overlays = overlays {inherit inputs;};
        }
      else systemConfiguration.pkgs;
    recipeBackend =
      if isHomeManagerOnly
      then
        if isDarwin
        then "darwin"
        else "nixos"
      else host.backend;
    homeModules = import ../config/recipe-modules.nix {
      inherit inputs host;
      backend = recipeBackend;
    };
    standaloneHomeModule = lib.optional isHomeManagerOnly {
      home.homeDirectory =
        host.homeDirectory
          or (
          if isDarwin
          then "/Users/${host.usernameLower}"
          else "/home/${host.usernameLower}"
        );
    };
  in {
    nixosConfigurations = acc.nixosConfigurations // system.nixosConfigurations;
    darwinConfigurations = acc.darwinConfigurations // system.darwinConfigurations;
    homeConfigurations =
      acc.homeConfigurations
      // {
        "${host.usernameLower}@${host.name}" = homeManager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {inherit inputs host;};
          modules = homeModules.home ++ standaloneHomeModule;
        };
      };
  })
  {
    nixosConfigurations = {};
    darwinConfigurations = {};
    homeConfigurations = {};
  }
  hosts
