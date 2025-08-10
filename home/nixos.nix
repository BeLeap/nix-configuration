{ metadata, pkgs, ... }:
{
  imports = [
    ./common.nix
  ]
  ++ map (p: (./. + "/programs/${p}")) [
    "hyprland"
    "rofi"
  ];

  home.packages = with pkgs; [
    alacritty
  ];

  home.homeDirectory = "/home/${metadata.usernameLower}";
}
