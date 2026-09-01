# Include WezTerm workspace in Pi notifications

Updated `config/recipe/pi/notify-osc.ts` to look up the WezTerm workspace for
the current `WEZTERM_PANE` and include it in the OSC 777 notification title as
`Pi (<workspace>)`.

The lookup uses `wezterm cli list --format json` for each notification so the
title follows workspace changes during a Pi session. Pi continues to be usable
outside WezTerm, where the title remains `Pi`. Lookup and malformed-output
failures are reported to stderr with their underlying error instead of being
silently ignored.
