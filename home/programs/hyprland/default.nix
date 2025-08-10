{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;

    xwayland.enable = true;
    systemd = {
      enable = true;
      enableXdgAutostart = true;
    };

    settings = {
      "$mod" = "SUPER";

      bind = [
        "$mod, x, exec, ${pkgs.foot}/bin/foot"
      ];

      input = {
        kb_variant = "colemak";
        kb_options = "ctrl:nocaps,korean:ralt_hangul";
      };

      monitor = [
        ", preferred, auto, 1"
      ];
    };
  };

  services.hyprpolkitagent = {
    enable = true;
  };
}
