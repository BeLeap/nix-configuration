{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;

    xwayland.enable = true;
    systemd.enable = true;

    enableXdgAutostart = true;

    settings = {
      "$mod" = "SUPER";

      bind = [
        "$mod, x, exec, ${pkgs.foot}/bin/foot"
      ];
    };
  };
}
