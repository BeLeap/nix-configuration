_: {
  programs.waybar = {
    enable = true;

    systemd.enable = true;

    settings = {
      mainBar = {
        modules-left = [ "hyprland/workspace" ];
      };
    };
  };
}
