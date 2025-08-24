_: {
  programs.wezterm = {
    enable = true;

    enableBashIntegration = true;
    enableZshIntegration = true;

    extraConfig = ''
      return {
        font = wezterm.font("Cascadia Code NF"),
        font_size = 16.0,
        color_scheme = "Catppuccin Frappe",
      }
    '';
  };
}
