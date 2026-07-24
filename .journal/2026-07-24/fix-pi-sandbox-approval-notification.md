# Fix OSC notifications for pi-sandbox approval prompts

Updated `config/recipe/pi/notify-osc.ts` to intercept `ctx.ui.custom` in addition to `ctx.ui.notify` and `ctx.ui.select`. `pi-sandbox` 0.5.0 renders read, write, and network approval prompts with a custom component; the extension now extracts that component's ANSI-stripped first rendered line and emits one OSC 777 notification per prompt.

Retained the select interception for extensions that use Pi's built-in select dialog.

## Validation

- `pi -ne -e ./config/recipe/pi/notify-osc.ts --list-models` loaded the extension successfully.
- Loaded a temporary fake custom-UI extension before `notify-osc.ts` and invoked its command in print mode. The wrapped component emitted exactly `OSC 777;notify;Pi;📝 Write blocked: "/outside" is not in allowWrite;BEL` (with the actual OSC/BEL control bytes).
- Inspected the tagged `pi-sandbox` 0.5.0 source (`cb28987360e7e458c60c945ff66e90ef93d26b96`): its permission flow calls `ctx.ui.custom`, and the first rendered line is the blocked-action title.
- Standalone `tsc` validation was unavailable because `tsc` is not installed in the current shell; Pi's runtime TypeScript loader accepted the extension.
