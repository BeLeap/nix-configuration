# Pi ctx.ui.notify OSC hook

Added a declarative Pi extension at `config/recipe/pi/notify-osc.ts` and linked it to
`~/.pi/agent/extensions/notify-osc.ts` via Home Manager.

The extension patches `ctx.ui.notify` during `session_start` and adds a
`/notify-osc-test` command. Every `ctx.ui.notify(message, level)` call now keeps the
normal Pi notification behavior and also writes both terminal notification escape
sequences in one stdout write:

- OSC 9: `ESC ] 9 ; message BEL`
- OSC 777: `ESC ] 777 ; notify ; title ; message BEL`

OSC fields are sanitized to remove control characters and semicolons so malformed
notification payloads are not emitted.
