{
  description = "BeLeap personal nix configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:BeLeap/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";
    mac-app-util.url = "github:hraban/mac-app-util";
    beleap-overlay.url = "github:BeLeap/nix-overlay";

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
                recipes = [ ];
              };
              effective = base // override;
              resolved = effective // {
                usernameLower = lib.toLower effective.username;
                platform = "${effective.arch}-${effective.os}";
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
              recipes = [ "macos/beleap-m1air" ];
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
              kind = "personal";
              os = "linux";
              arch = "aarch64";
              distribution = "nixos";
              gui = false;
              recipes = [
                "vm"
                "nixos/vm"
              ];
            }
            {
              name = "vm-arm64-Darwin-work";
              kind = "work";
              username = "cs.jang";
              email = "cs.jang@toss.im";
              os = "linux";
              arch = "aarch64";
              distribution = "nixos";
              gui = false;
              recipes = [
                "vm"
                "nixos/vm"
              ];
            }
          ];
    in
    lib.fold
      (
        metadata: acc:
        let
          recipes = [
            # base setup
            "overlay"
            "hm"
            "macAppUtil"

            # good to share among all hosts
            "base"
            "nix"

            "macos"
            "nixos"

            "development"

            # others
            "kubernetes"
            "1password"
          ]
          ++ metadata.recipes;
          system = callPackage ./mkSystem.nix { inherit metadata recipes; };
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
