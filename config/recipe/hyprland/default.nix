_: {
  hm = [
    (
      {pkgs, ...}: {
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
              "$mod, t, exec, ${pkgs.wezterm}/bin/wezterm"
              "$mod, r, exec, ${pkgs.rofi}/bin/rofi -show drun"
              "$mod shift, k, killactive"
            ];

            decoration = {
              rounding = 10;
            };

            input = {
              kb_variant = "colemak";
              kb_options = "ctrl:nocaps,korean:ralt_hangul";
            };

            monitor = [
              "Virtual-1, 3840x2160@60, auto, 1.6"
              ", preferred, auto, 1"
            ];
          };
        };

        services.hyprpolkitagent = {
          enable = true;
        };
      }
    )
  ];
}
