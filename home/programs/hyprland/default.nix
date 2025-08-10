{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mod" = "SUPER";

      bind = [
        "$mod, x, exec, ${pkgs.foot}/bin/foot"
      ];
    };
  };
}
