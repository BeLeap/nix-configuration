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

  outputs = inputs@{ self, nix-darwin, nixpkgs, ... }:
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#beleap-m1air
    darwinConfigurations."beleap-m1air" = nix-darwin.lib.darwinSystem {
      modules = [
        ./configurations/macos/beleap-m1air/configuartion.nix
      ];
    };
  };
}
