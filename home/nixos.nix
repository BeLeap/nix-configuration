{ metadata, ... }:
{
  imports = [
    ./common.nix
  ];

  home.homeDirectory = "/home/${metadata.usernameLower}";

  wayland = {
    windowManager.hyprland = {
      enable = true;
    };
  };
}
