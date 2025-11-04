local wezterm = require 'wezterm';
local act = wezterm.action;

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

config.use_fancy_tab_bar = true;

config.leader = { key = 'a', mods = 'CTRL', timout_milliseconds = 1000 };
config.keys = {
   -- Double tap CTRL-a to send CTRL-a to terminal
  { key = 'a', mods = 'LEADER|CTRL', action = act.SendKey { key = 'a', mods = 'CTRL' } },

  { key = '%', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '"', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

  { key = 'q', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },

  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'LeftArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'DownArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'UpArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
  { key = 'RightArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },

  { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },
  { key = ']', mods = 'LEADER', action = act.PasteFrom('PrimarySelection') },
};

for i = 1, 8 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = act.ActivateTab(i - 1),
  })
end

config.key_tables = {
  copy_mode = {
    { key = 'Escape', mods = 'NONE', action = act.CopyMode('Close') },

    { key = 'h', mods = 'NONE', action = act.CopyMode('MoveLeft') },
    { key = 'j', mods = 'NONE', action = act.CopyMode('MoveDown') },
    { key = 'k', mods = 'NONE', action = act.CopyMode('MoveUp') },
    { key = 'l', mods = 'NONE', action = act.CopyMode('MoveRight') },

    { key = 'w', mods = 'NONE', action = act.CopyMode('MoveForwardWord') },
    { key = 'b', mods = 'NONE', action = act.CopyMode('MoveBackwardWord') },

    { key = '0', mods = 'NONE', action = act.CopyMode('MoveToStartOfLine') },
    { key = 'Enter', mods = 'NONE', action = act.CopyMode('MoveToStartOfNextLine') },

    { key = '$', mods = 'NONE', action = act.CopyMode('MoveToStartOfNextLine') },
    { key = '^', mods = 'NONE', action = act.CopyMode('MoveToStartOfLineContent') },

    { key = ' ', mods = 'NONE', action = act.CopyMode { SetSelectionMode = 'Cell' } },
    { key = 'v', mods = 'NONE', action = act.CopyMode { SetSelectionMode = 'Cell' } },
    { key = 'v', mods = 'SHIFT', action = act.CopyMode { SetSelectionMode = 'Line' } },
    { key = 'v', mods = 'CTRL', action = act.CopyMode { SetSelectionMode = 'Block' } },

    { key = 'G', mods = 'NONE', action = act.CopyMode('MoveToScrollbackBottom') },
    { key = 'g', mods = 'NONE', action = act.CopyMode('MoveToScrollbackTop') },

    { key = 'u', mods = 'CTRL', action = act.CopyMode('PageUp') },
    { key = 'b', mods = 'CTRL', action = act.CopyMode('PageDown') },

    { key = 'y', mods = 'NONE', action = act.Multiple {
      act.CopyTo('ClipboardAndPrimarySelection'),
      act.CopyMode('Close')
    }},

    { key = '/', mods = 'NONE', action = act{ Search = { CaseSensitiveString = "" } } },
    { key = '?', mods = 'NONE', action = act{ Search = { CaseInSensitiveString = "" } } },
    { key = 'n', mods = 'CTRL', action = act{ CopyMode = 'NextMatch' } },
    { key = 'p', mods = 'CTRL', action = act{ CopyMode = 'PriorMatch' } },
  },
  search_mode = {
    { key = 'Escape', mods = 'NONE', action = act.CopyMode('Close') },
    { key = 'Enter', mods = 'NONE', action = 'ActivateCopyMode'},

    { key = 'n', mods = 'CTRL', action = act{ CopyMode = 'NextMatch' } },
    { key = 'p', mods = 'CTRL', action = act{ CopyMode = 'PriorMatch' } },

    { key = "u", mods = "CTRL", action = act.CopyMode('ClearPattern') },
  },
};

return config;
