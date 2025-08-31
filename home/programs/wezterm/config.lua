local config = {};

config.term = "xterm-256color";

config.font = wezterm.font_with_fallback {
  { family = "Cascadia Code NF" },
  { family = "NanumGothicCoding" },
};
config.font_size = 16.0;
config.window_frame = {
  font = wezterm.font("Cascadia Code NF"),
};

config.color_scheme = "Catppuccin Frappe";
config.window_decorations = "RESIZE";

config.leader = { key = 'a', mods = 'CTRL', timout_milliseconds = 1000 };
config.keys = {
   -- Double tap CTRL-a to send CTRL-a to terminal
  { key = 'a', mods = 'LEADER|CTRL', action = wezterm.action.SendKey { key = 'a', mods = 'CTRL' } },

  { key = '%', mods = 'LEADER', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '"', mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },

  { key = 'h', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Right' },
};

for i = 1, 8 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = wezterm.action.ActivateTab(i - 1),
  })
end

return config;
