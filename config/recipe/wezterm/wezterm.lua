local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()
local terminal_font = wezterm.font 'Hanadia Mono'
local copy_mode = nil

if wezterm.gui then
  copy_mode = wezterm.gui.default_key_tables().copy_mode
  table.insert(copy_mode, { key = 'j', mods = 'CMD', action = act.QuickSelect })
end

config.default_prog = { '@zsh@', '-l' }
config.default_workspace = 'sp'

config.front_end = 'Software'

config.window_close_confirmation = "NeverPrompt"

config.color_scheme = 'Gruvbox dark, medium (base16)'
config.font = terminal_font
config.window_frame = {
  font = terminal_font,
}
config.font_size = 16
config.window_decorations = 'RESIZE'
config.notification_handling = 'AlwaysShow'
config.quick_select_patterns = {
  [[push-\S*]],
}
config.window_padding = {
  left = 8,
  right = 8,
  top = 0,
  bottom = 0,
}

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.key_tables = {
  copy_mode = copy_mode,
}

wezterm.on('user-var-changed', function(window, pane, name, value)
  if name ~= 'DO_FOCUS_WEZTERM_WORKSPACE' or value == '' then
    return
  end

  local ok, err = pcall(wezterm.mux.set_active_workspace, value)
  if not ok then
    wezterm.log_error('failed to switch workspace via wzs: ' .. tostring(err))
  end
end)

wezterm.on('update-right-status', function(window, pane)
  window:set_right_status(window:active_workspace() .. ' ')
end)

local function spawn_tiled_pane(_, pane)
  local panes = pane:tab():panes_with_info()
  local split_target = pane
  local direction = 'Right'

  if #panes > 1 then
    local rightmost

    for _, pane_info in ipairs(panes) do
      if not rightmost
        or pane_info.left > rightmost.left
        or (pane_info.left == rightmost.left and pane_info.height > rightmost.height)
      then
        rightmost = pane_info
      end
    end

    split_target = rightmost.pane
    direction = 'Bottom'
  end

  split_target:split { direction = direction }
end

config.keys = {
  { key = 'n', mods = 'LEADER', action = wezterm.action_callback(spawn_tiled_pane) },
  { key = 'r', mods = 'LEADER', action = act.RotatePanes 'Clockwise' },
  { key = 'a', mods = 'LEADER|CTRL', action = act.SendKey { key = 'a', mods = 'CTRL' } },
  { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = '%', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '"', mods = 'LEADER|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
  { key = 's', mods = 'LEADER', action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' } },
  { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
  { key = 'H', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Left', 5 } },
  { key = 'J', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Down', 5 } },
  { key = 'K', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Up', 5 } },
  { key = 'L', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Right', 5 } },
  { key = '1', mods = 'LEADER', action = act.ActivateTab(0) },
  { key = '2', mods = 'LEADER', action = act.ActivateTab(1) },
  { key = '3', mods = 'LEADER', action = act.ActivateTab(2) },
  { key = '4', mods = 'LEADER', action = act.ActivateTab(3) },
  { key = '5', mods = 'LEADER', action = act.ActivateTab(4) },
  { key = '6', mods = 'LEADER', action = act.ActivateTab(5) },
  { key = '7', mods = 'LEADER', action = act.ActivateTab(6) },
  { key = '8', mods = 'LEADER', action = act.ActivateTab(7) },
  { key = '9', mods = 'LEADER', action = act.ActivateTab(8) },
}

return config
