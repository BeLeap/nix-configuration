{
  description = "BeLeap personal nix configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      environment.systemPackages = [];
      programs.zsh.enable = true;
      
      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";
      
      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;
      
      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#beleap-m1air
    darwinConfigurations."beleap-m1air" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
