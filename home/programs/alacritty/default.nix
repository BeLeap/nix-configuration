_: {
  programs.alacritty = {
    enable = true;

    theme = "catppuccin_frappe";

    settings = {
      font = {
        normal = {
          family = "Cascadia Code NF";
        };
      };

      window = {
        padding = {
          x = 10;
        };
        startup_mode = "Maximized";
        decorations = "Buttonless";
      };
    };
  };
}
