# Debug Rio OSC notifications

Date: 2026-11-13

## Findings

- The Pi process for this conversation was PID `61826`, a child of WezTerm PID `43200` on `ttys001`.
- Rio's Zellij client was PID `39319` on `ttys002`.
- Zellij session `sp` contained shell pane `terminal_8` and no Pi process.
- `config/recipe/pi/notify-osc.ts` emits OSC 777. The loaded Zellij config sets `host_notification_protocol "osc9"`.

## Runtime probe

- Sent OSC 777 through a short-lived, no-focus pane in session `sp`.
- macOS logged a notification request for bundle `com.raphaelamorim.rio`.
- The log recorded `shouldPresent=true` and `Presenting ... as banner`.
- This confirmed the OSC 777 → Zellij OSC 9 → Rio → Notification Center path.
- This did not test the Pi extension from a Pi process inside Rio.

## Result

- The active Pi process runs under WezTerm, so its OSC output does not route through Rio.
- The next diagnostic is to run Pi inside Rio's session `sp` and execute `/notify-osc-test Rio test`.
- No source or configuration files changed.
- An initial probe omitted `ZELLIJ_SOCKET_DIR` and created an isolated temporary Zellij server. I stopped that server after confirming it had no child processes.
