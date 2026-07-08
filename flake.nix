{
  description = "BeLeap personal nix configurations";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.numtide.com"
      "https://beleap-nix-overlay.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "beleap-nix-overlay.cachix.org-1:SJdfYkwp5t+YoeraOtUcqyKIxvnWQ1GdiNoC21F+En0="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:BeLeap/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";
    llm-agents.url = "github:numtide/llm-agents.nix";
    mac-app-util.url = "github:hraban/mac-app-util";
    beleap-overlay.url = "github:BeLeap/nix-overlay";
    direnv-overlay.url = "github:BeLeap/direnv-overlay";
    direnv-instant.url = "github:Mic92/direnv-instant/untagged-de17ad4b5aee16b95332";
    jj-starship.url = "github:dmmulroy/jj-starship/v0.7.1";
    try.url = "github:tobi/try/v1.9.0";
  };

  outputs = inputs @ {nixpkgs, ...}: let
    inherit (nixpkgs) lib;
    callPackage = lib.callPackageWith (inputs // {inherit lib;});
    mkMetadata = import ./lib/metadata.nix {inherit lib;};
    metadatas = map mkMetadata (import ./config/hosts.nix);
    systems = lib.unique (map (metadata: metadata.platform) metadatas);
  in
    (import ./lib/build-configs.nix {
      inherit lib callPackage metadatas;
    })
    // {
      formatter = lib.genAttrs systems (system: (import nixpkgs {inherit system;}).alejandra);
      devShells = lib.genAttrs systems (system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        default = pkgs.mkShell {
          packages = with pkgs; [
            alejandra
            deadnix
            statix
          ];
        };
      });
    };
}
