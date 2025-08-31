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

  leader = { key = 'a', mods = 'CTRL', timout_milliseconds = 1000 },
  keys = {
    { key = '%', mods = 'LEADER', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = '"', mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 'h', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Left' },
    { key = 'j', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Down' },
    { key = 'k', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Up' },
    { key = 'l', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Right' },
  };
}
