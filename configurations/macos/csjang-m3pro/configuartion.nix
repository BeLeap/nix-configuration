{ inputs, username, ... }:
{
  imports = [
    ../../common/common.nix
    (import ../common/common.nix { inherit username; })
  ];

  nixpkgs = {
    config.allowUnfree = true;
  };

  environment.systemPackages = [ ];
  programs.zsh.enable = true;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
