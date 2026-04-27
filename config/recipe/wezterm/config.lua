local wezterm = require 'wezterm';
local act = wezterm.action;

local config = {};

config.term = "xterm-256color";

config.font = wezterm.font_with_fallback {
  { family = "Hack Nerd Font" },
  { family = "NanumGothicCoding" },
};
config.font_size = 16.0;
config.window_frame = {
  font = wezterm.font("Hack Nerd Font"),
};

config.color_scheme = "Catppuccin Mocha";
config.window_decorations = "RESIZE";
config.window_close_confirmation = "NeverPrompt";

config.enable_tab_bar = false;
config.keys = {};
config.default_prog = { "@ZSH@", "-l", "-i", "-c", "@TMUX@" };

return config;
