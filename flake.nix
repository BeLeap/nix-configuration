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
      lib = nixpkgs.lib;
      overlays = with inputs; [
        (import ./pkgs/overlay.nix {
          inherit kubectl-check boda;
        })
      ];
      metadatas =
        builtins.map
          (
            initial:
            let
              username = (if initial.kind == "personal" then "BeLeap" else initial.username);
              usernameLower = lib.toLower username;
              email = (if initial.kind == "personal" then "beleap@beleap.dev" else initial.email);
            in
            initial // { inherit username usernameLower email; }
          )
          [
            {
              name = "beleap-m1air";
              kind = "personal";
              os = "macos";
            }
            {
              name = "csjang-m3pro";
              kind = "work";
              username = "cs.jang";
              email = "cs.jang@toss.im";
              os = "macos";
            }
            {
              name = "utm-personal";
              kind = "personal";
              os = "nixos";
            }
          ];
      commonModules = (
        metadata: [
          { nixpkgs.overlays = overlays; }
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";
            home-manager.extraSpecialArgs = { inherit metadata; };
          }
          (./configurations/common)
        ]
      );
    in
    {
      darwinConfigurations = lib.pipe metadatas [
        (metadatas: builtins.filter (metadata: metadata.os == "macos") metadatas)
        (
          metadatas:
          (lib.foldl (
            acc: metadata:
            acc
            // {
              "${metadata.name}" = nix-darwin.lib.darwinSystem {
                specialArgs = { inherit inputs metadata; };
                modules = (commonModules metadata) ++ [
                  inputs.mac-app-util.darwinModules.default
                  (./configurations/macos/common)
                  (./. + "/configurations/macos/${metadata.name}/configuartion.nix")
                  home-manager.darwinModules.home-manager
                  {
                    home-manager.sharedModules = [
                      inputs.mac-app-util.homeManagerModules.default
                    ];
                    home-manager.users."${metadata.usernameLower}" = ./home/darwin.nix;
                  }
                ];
              };
            }
          ) { } metadatas)
        )
      ];
    };
}
