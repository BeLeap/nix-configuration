import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const PATCHED_NOTIFY = Symbol.for("beleap.notify-osc.patched");
const OSC = "\x1b]";
const BEL = "\x07";

type NotifyLevel = "info" | "warning" | "error";
type NotifyFn = (message: string, level?: NotifyLevel) => void;
type PatchableUi = {
  notify: NotifyFn;
  [PATCHED_NOTIFY]?: boolean;
};

function sanitizeOscField(value: string): string {
  return value.replace(/[\x00-\x1f\x7f;]/g, " ").trim();
}

function notificationTitle(level: NotifyLevel | undefined): string {
  switch (level) {
    case "warning":
      return "Pi warning";
    case "error":
      return "Pi error";
    default:
      return "Pi";
  }
}

function oscNotifications(message: string, level: NotifyLevel | undefined): string {
  const body = sanitizeOscField(message);
  const title = sanitizeOscField(notificationTitle(level));

  return `${OSC}9;${body}${BEL}${OSC}777;notify;${title};${body}${BEL}`;
}

function patchNotify(ctx: ExtensionContext): void {
  const ui = ctx.ui as PatchableUi;

  if (ui[PATCHED_NOTIFY]) {
    return;
  }

  const originalNotify = ui.notify.bind(ui);

  ui.notify = (message: string, level?: NotifyLevel) => {
    originalNotify(message, level);
    process.stdout.write(oscNotifications(message, level));
  };
  ui[PATCHED_NOTIFY] = true;
}

export default function (pi: ExtensionAPI) {
  pi.on("session_start", async (_event, ctx) => {
    patchNotify(ctx);
  });

  pi.registerCommand("notify-osc-test", {
    description: "Send a test notification through ctx.ui.notify and OSC 9/777.",
    handler: async (args, ctx) => {
      patchNotify(ctx);
      ctx.ui.notify(args.trim() || "Pi OSC notifications are enabled.", "info");
    },
  });
}
