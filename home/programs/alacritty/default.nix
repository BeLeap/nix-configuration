_: {
  programs.alacritty = {
    enable = true;

    theme = "catppuccin_frappe";

    settings = {
      font = {
        normal = {
          family = "Cascadia Code NF";
        };
        size = 16;
      };

      window = {
        padding = {
          x = 10;
          y = 10;
        };
        startup_mode = "Maximized";
        decorations = "Buttonless";
      };
    };
  };
}
