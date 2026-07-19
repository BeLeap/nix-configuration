import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const PATCHED_NOTIFY = Symbol.for("beleap.notify-osc.patched");
const PATCHED_SELECT = Symbol.for("beleap.notify-osc.select-patched");
const OSC = "\x1b]";
const BEL = "\x07";

type NotifyLevel = "info" | "warning" | "error";
type PatchableUi = ExtensionContext["ui"] & {
  [PATCHED_NOTIFY]?: boolean;
  [PATCHED_SELECT]?: boolean;
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

function osc777Notification(message: string, level: NotifyLevel | undefined): string {
  const body = sanitizeOscField(message);
  const title = sanitizeOscField(notificationTitle(level));

  return `${OSC}777;notify;${title};${body}${BEL}`;
}

function patchUi(ctx: ExtensionContext): void {
  const ui = ctx.ui as PatchableUi;

  if (!ui[PATCHED_NOTIFY]) {
    const originalNotify = ui.notify.bind(ui);

    ui.notify = (message: string, level?: NotifyLevel) => {
      originalNotify(message, level);
      process.stdout.write(osc777Notification(message, level));
    };
    ui[PATCHED_NOTIFY] = true;
  }

  if (!ui[PATCHED_SELECT]) {
    const originalSelect = ui.select.bind(ui);

    ui.select = ((...args: Parameters<ExtensionContext["ui"]["select"]>) => {
      const [title] = args;
      process.stdout.write(osc777Notification(title, "warning"));
      return originalSelect(...args);
    }) as ExtensionContext["ui"]["select"];
    ui[PATCHED_SELECT] = true;
  }
}

export default function (pi: ExtensionAPI) {
  pi.on("session_start", async (_event, ctx) => {
    patchUi(ctx);
  });

  pi.registerCommand("notify-osc-test", {
    description: "Send a test notification through ctx.ui.notify and OSC 777.",
    handler: async (args, ctx) => {
      patchUi(ctx);
      ctx.ui.notify(args.trim() || "Pi OSC notifications are enabled.", "info");
    },
  });

  pi.registerCommand("notify-osc-select-test", {
    description: "Test OSC notification forwarding for ctx.ui.select.",
    handler: async (_args, ctx) => {
      patchUi(ctx);
      await ctx.ui.select("OSC select UI test", ["Close"]);
    },
  });
}
