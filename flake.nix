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
            override:
            let
              base = {
                username = "BeLeap";
                email = "beleap@beleap.dev";
                extraModule = [ ];
                extraConfig = { };
              };
              effective = base // override;
              resolved = effective // {
                usernameLower = lib.toLower effective.username;
                platform = "${effective.arch}-${effective.os}";
                configPath = effective.configPath or effective.name;
              };
            in
            resolved
          )
          [
            {
              name = "beleap-m1air";
              kind = "personal";
              os = "darwin";
              arch = "aarch64";
              distribution = "macos";
              gui = true;
            }
            {
              name = "csjang-m3pro";
              kind = "work";
              username = "cs.jang";
              email = "cs.jang@toss.im";
              os = "darwin";
              arch = "aarch64";
              distribution = "macos";
              gui = true;
            }
            {
              name = "vm-arm64-Darwin-personal";
              configPath = "vm";
              kind = "personal";
              os = "linux";
              arch = "aarch64";
              distribution = "nixos";
              gui = false;
              extraConfig = {
                boot.binfmt.emulatedSystems = [
                  "x86_64-linux"
                ];
                virtualisation.sharedDirectories = {
                  defaultShared = {
                    source = "/Users/beleap/shared";
                    target = "/home/beleap/shared";
                  };
                };
              };
              extraModule = [
                {
                  virtualisation.host.pkgs = nixpkgs.legacyPackages.aarch64-darwin;
                }
              ];
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
      nixosConfigurations = lib.pipe metadatas [
        (metadatas: builtins.filter (metadata: metadata.distribution == "nixos") metadatas)
        (
          metadatas:
          (lib.foldl (
            acc: metadata:
            acc
            // {
              "${metadata.name}" = nixpkgs.lib.nixosSystem {
                system = metadata.platform;
                specialArgs = { inherit inputs metadata nixpkgs; };
                modules =
                  (commonModules metadata)
                  ++ [
                    (./configurations/nixos/common)
                    (./. + "/configurations/nixos/${metadata.configPath}/configuration.nix")
                    home-manager.nixosModules.home-manager
                    {
                      home-manager.users."${metadata.usernameLower}" = ./home/nixos.nix;
                    }
                  ]
                  ++ (metadata.extraModule);
              };
            }
          ) { } metadatas)
        )
      ];
      darwinConfigurations = lib.pipe metadatas [
        (metadatas: builtins.filter (metadata: metadata.distribution == "macos") metadatas)
        (
          metadatas:
          (lib.foldl (
            acc: metadata:
            acc
            // {
              "${metadata.name}" = nix-darwin.lib.darwinSystem {
                specialArgs = { inherit inputs metadata; };
                modules =
                  (commonModules metadata)
                  ++ [
                    inputs.mac-app-util.darwinModules.default
                    (./configurations/macos/common)
                    (./. + "/configurations/macos/${metadata.configPath}/configuartion.nix")
                    home-manager.darwinModules.home-manager
                    {
                      home-manager.sharedModules = [
                        inputs.mac-app-util.homeManagerModules.default
                      ];
                      home-manager.users."${metadata.usernameLower}" = ./home/darwin.nix;
                    }
                  ]
                  ++ (metadata.extraModule);
              };
            }
          ) { } metadatas)
        )
      ];
    };
}
