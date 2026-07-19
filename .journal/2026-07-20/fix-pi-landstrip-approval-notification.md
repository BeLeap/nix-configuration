# Fix OSC notifications for pi-landstrip approval prompts

Updated `config/recipe/pi/notify-osc.ts` to patch `ctx.ui.select` instead of `ctx.ui.custom`. `pi-landstrip` 0.17.7 replaced its custom approval overlay with Pi's built-in select prompt, so the old render interception no longer observed approval requests. The select title is now sent directly as an OSC 777 warning notification, and the test command is now `/notify-osc-select-test`.

Validation:

- `pi -ne -e ./config/recipe/pi/notify-osc.ts --list-models` loaded the extension successfully.
- `pi -ne -e ./config/recipe/pi/notify-osc.ts -p '/notify-osc-select-test'` emitted the expected `OSC 777;notify;Pi warning;OSC select UI test` sequence (Pi routes extension writes to stderr in print mode).
