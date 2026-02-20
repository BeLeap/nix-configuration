_: {
  hm = [
    {
      programs.waybar = {
        enable = true;

        systemd = {
          enable = true;
          target = "hyprland-session.target";
        };

        settings = {
          mainBar = {
            modules-left = ["hyprland/workspaces"];
          };
        };
      };
    }
  ];
}
