# Match WezTerm tab bar font

- Introduced a shared `terminal_font` value in the WezTerm Lua configuration.
- Reused that font for both `config.font` and `config.window_frame.font` so the tab bar uses the same font as terminal panes.
