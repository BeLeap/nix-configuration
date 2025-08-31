return {
  font = wezterm.font_with_fallback {
    {
      family = "Cascadia Code NF"
    },
    {
      family = "NanumGothicCoding"
    },
  },
  font_size = 16.0,
  color_scheme = "Catppuccin Frappe",

  window_frame = {
    font = wezterm.font("Cascadia Code NF"),
  },
  window_decorations = "RESIZE",

  leader = {},
}
