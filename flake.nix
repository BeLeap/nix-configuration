{
  description = "BeLeap personal nix configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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
      callPackage = lib.callPackageWith (inputs // { inherit lib; });
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
            {
              name = "vm-arm64-Darwin-work";
              configPath = "vm";
              kind = "work";
              username = "cs.jang";
              email = "cs.jang@toss.im";
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
                    source = "/Users/cs.jang/shared";
                    target = "/home/cs.jang/shared";
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
    in
    lib.fold
      (
        metadata: acc:
        let
          system = callPackage ./mkSystem.nix { inherit metadata; };
        in
        ({
          nixosConfigurations = acc.nixosConfigurations // system.nixosConfigurations;
          darwinConfigurations = acc.darwinConfigurations // system.darwinConfigurations;
        })
      )
      {
        nixosConfigurations = { };
        darwinConfigurations = { };
      }
      metadatas;
}
