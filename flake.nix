{
  description = "BeLeap personal nix configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      home-manager,
      nixpkgs,
      ...
    }:
    {
      darwinConfigurations =
        builtins.mapAttrs
          (
            name: value:
            let
              kind = value.kind;
              username = (if kind == "personal" then "beleap" else value.username);
            in
            nix-darwin.lib.darwinSystem {
              specialArgs = { inherit inputs kind; };
              modules = [
                ./configurations/macos/beleap-m1air/configuartion.nix
                home-manager.darwinModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.backupFileExtension = "bak";
                  home-manager.users."${username}" = ./home/darwin.nix;
                  home-manager.extraSpecialArgs = { inherit kind username; };
                }
              ];
            }
          )
          {
            beleap-m1air = {
              kind = "personal";
            };
            csjang-m3pro = {
              kind = "work";
              username = "cs.jang";
            };
          };
    };
}
