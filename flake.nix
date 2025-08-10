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
    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Custom Packages
    kubectl-check = {
      url = "github:BeLeap/kubectl-check";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    boda = {
      url = "github:BeLeap/boda";
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
    let
      overlays = with inputs; [
        (import ./pkgs/overlay.nix {
          inherit kubectl-check boda;
        })
      ];
    in
    {
      darwinConfigurations =
        builtins.mapAttrs
          (
            name: value:
            let
              metadata =
                let
                  kind = value.kind;
                  username = (if kind == "personal" then "BeLeap" else value.username);
                  usernameLower = nixpkgs.lib.toLower metadata.username;
                  email = (if kind == "personal" then "beleap@beleap.dev" else value.email);
                  os = value.os;
                in
                {
                  inherit
                    kind
                    username
                    usernameLower
                    email
                    os
                    ;
                };
            in
            nix-darwin.lib.darwinSystem {
              specialArgs = { inherit inputs metadata; };
              modules = [
                { nixpkgs.overlays = overlays; }
                inputs.mac-app-util.darwinModules.default
                (./. + "/configurations/macos/${name}/configuartion.nix")
                home-manager.darwinModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.backupFileExtension = "bak";
                  home-manager.sharedModules = [
                    inputs.mac-app-util.homeManagerModules.default
                  ];
                  home-manager.users."${metadata.usernameLower}" = ./home/darwin.nix;
                  home-manager.extraSpecialArgs = { inherit metadata; };
                }
              ];
            }
          )
          {
            beleap-m1air = {
              kind = "personal";
              os = "macos";
            };
            csjang-m3pro = {
              kind = "work";
              username = "cs.jang";
              email = "cs.jang@toss.im";
              os = "macos";
            };
          };
    };
}
