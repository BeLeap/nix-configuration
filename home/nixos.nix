{ metadata, ... }:
{
  imports = [
    ./common.nix
  ]
  ++ map (p: (./. + "/programs/${p}")) [
    "hyprland"
  ];

  home.homeDirectory = "/home/${metadata.usernameLower}";

  wayland = {
    windowManager.hyprland.enable = true;
  };
}
