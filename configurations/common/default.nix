{ pkgs, ... }:
{
  nix.optimise.automatic = true;

  nixpkgs = {
    config.allowUnfree = true;
  };

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  time.timeZone = "Asia/Seoul";

  environment.systemPackages = with pkgs; [
    vim
    curl
    git
  ];
}
