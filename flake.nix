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
              metadata =
                let
                  username = (if kind == "personal" then "BeLeap" else value.username);
                  usernameLower = nixpkgs.lib.toLower metadata.username;
                  email = (if kind == "personal" then "beleap@beleap.dev" else value.email);
                in
                {
                  inherit username usernameLower email;
                };
            in
            nix-darwin.lib.darwinSystem {
              specialArgs = { inherit inputs kind metadata; };
              modules = [
                (./. + "/configurations/macos/${name}/configuartion.nix")
                home-manager.darwinModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.backupFileExtension = "bak";
                  home-manager.users."${metadata.usernameLower}" = ./home/darwin.nix;
                  home-manager.extraSpecialArgs = { inherit kind metadata; };
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
              email = "cs.jang@toss.im";
            };
          };
    };
}
