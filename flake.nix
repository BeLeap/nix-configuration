{
  description = "BeLeap personal nix configurations";

  nixConfig = {
    extra-substituters = ["https://cache.numtide.com"];
    extra-trusted-public-keys = ["niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="];
  };

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
    llm-agents.url = "github:numtide/llm-agents.nix";
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

  outputs = inputs @ {
    self,
    nix-darwin,
    home-manager,
    nixpkgs,
    ...
  }: let
    inherit (nixpkgs) lib;
    callPackage = lib.callPackageWith (inputs // {inherit lib;});
    mkMetadata = import ./lib/metadata.nix {inherit lib;};
    metadatas = map mkMetadata (import ./config/hosts.nix);
    baseRecipes = import ./config/recipes.nix;
    systems = lib.unique (map (metadata: metadata.platform) metadatas);
  in
    (import ./lib/build-configs.nix {
      inherit lib callPackage metadatas baseRecipes;
    })
    // {
      formatter = lib.genAttrs systems (system: (import nixpkgs {inherit system;}).alejandra);
    };
}
