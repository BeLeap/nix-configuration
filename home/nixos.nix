{
  metadata,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./common.nix
  ]
  ++ (lib.optionals (metadata.gui) (
    map (p: (./. + "/programs/${p}")) [
      "hyprland"
      "rofi"
      "waybar"
    ]
  ));

  home.packages =
    [ ]
    ++ (lib.optionals (metadata.gui) (
      with pkgs;
      [
        wezterm
      ]
    ));

  home.homeDirectory = "/home/${metadata.usernameLower}";
}
