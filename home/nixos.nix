{
  metadata,
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

  home.packages = [ ];
}
