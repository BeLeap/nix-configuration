_: {
  programs.waybar = {
    enable = true;

    systemd.enable = true;

    settings = {
      modules-left = [ "hyprland/workspace" ];
    };
  };
}
