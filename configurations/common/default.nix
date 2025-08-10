{ metadata, pkgs, ... }:
{
  nix.optimise.automatic = true;

  nixpkgs = {
    config.allowUnfree = true;
  };
  system.primaryUser = metadata.usernameLower;

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
}
