{
  metadata,
  lib,
  ...
}:
{
  imports = lib.optionals (metadata.gui) (
    map (p: (./. + "/programs/${p}")) [
      "hyprland"
      "rofi"
      "waybar"
    ]
  );

  home.packages = [ ];

  xdg.enable = true;
  xdg.userDirs.enable = true;
}
