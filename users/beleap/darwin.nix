{ pkgs, ... }: {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "25.11";

  home.packages = [
    pkgs.htop
  ];
}
