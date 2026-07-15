# Fix Pi OSC notify duplicate notifications

Changed `config/recipe/pi/notify-osc.ts` to emit only OSC 777 for terminal
notifications instead of both OSC 9 and OSC 777. Some terminals handle both
protocols and produce two desktop notifications for a single `ctx.ui.notify`
call when both sequences are written.

OSC 777 is preferred for this setup because it keeps the notification title
separate from the body, including the warning/error title mapping.

Also updated the `/notify-osc-test` command description to mention OSC 777 only.
