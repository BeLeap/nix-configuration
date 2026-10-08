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

local function get_right_column_panes(tab)
  local panes = tab:panes_with_info()
  local rightmost_left = 0

  for _, pane_info in ipairs(panes) do
    rightmost_left = math.max(rightmost_left, pane_info.left)
  end

  local right_panes = {}
  for _, pane_info in ipairs(panes) do
    if pane_info.left == rightmost_left then
      table.insert(right_panes, pane_info)
    end
  end

  table.sort(right_panes, function(a, b)
    if a.top == b.top then
      return a.index < b.index
    end
    return a.top < b.top
  end)

  return right_panes
end

local function equalize_right_panes(window, tab)
  local right_panes = get_right_column_panes(tab)
  if #right_panes < 2 then
    return
  end

  local total_height = 0

  for _, pane_info in ipairs(right_panes) do
    total_height = total_height + pane_info.height
  end

  local target_height = math.floor(total_height / #right_panes)
  local extra_rows = total_height % #right_panes

  for index = 1, #right_panes - 1 do
    right_panes = get_right_column_panes(tab)
    local pane_info = right_panes[index]
    local target = target_height + (index <= extra_rows and 1 or 0)
    local delta = target - pane_info.height

    if delta ~= 0 then
      local direction = delta > 0 and 'Down' or 'Up'
      window:perform_action(act.AdjustPaneSize { direction, math.abs(delta) }, pane_info.pane)
    end
  end
end

local function spawn_tiled_pane(window, pane)
  local tab = pane:tab()
  local right_panes = get_right_column_panes(tab)
  local split_target = pane
  local direction = 'Right'

  if #right_panes > 0 and #tab:panes() > 1 then
    -- Split the bottom pane so the right column stays a resizeable vertical chain.
    split_target = right_panes[#right_panes].pane
    direction = 'Bottom'
  end

  local new_pane = split_target:split { direction = direction }
  equalize_right_panes(window, tab)
  new_pane:activate()
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
