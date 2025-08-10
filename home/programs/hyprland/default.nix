{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;

    xwayland.enable = true;
    systemd.enable = true;

    withUWSM = true;

    settings = {
      "$mod" = "SUPER";

      bind = [
        "$mod, x, exec, ${pkgs.foot}/bin/foot"
      ];
    };
  };
}
