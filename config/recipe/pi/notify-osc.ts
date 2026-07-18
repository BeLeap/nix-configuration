import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const PATCHED_NOTIFY = Symbol.for("beleap.notify-osc.patched");
const PATCHED_CUSTOM = Symbol.for("beleap.notify-osc.custom-render-patched.v2");
const OSC = "\x1b]";
const BEL = "\x07";

type NotifyLevel = "info" | "warning" | "error";
type PatchableUi = ExtensionContext["ui"] & {
  [PATCHED_NOTIFY]?: boolean;
  [PATCHED_CUSTOM]?: boolean;
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

function stripAnsi(value: string): string {
  return value.replace(/\x1b\[[0-?]*[ -/]*[@-~]/g, "");
}

function customUiNotificationMessage(lines: string[]): string {
  const firstLine = stripAnsi(lines[0] ?? "")
    .replace(/^[\s\u2500-\u257f+|=\-]+/u, "")
    .replace(/[\s\u2500-\u257f+|=\-]+$/u, "")
    .trim();

  return firstLine || "Unknown request.";
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

  if (!ui[PATCHED_CUSTOM]) {
    const originalCustom = ui.custom.bind(ui);

    ui.custom = ((...args: Parameters<ExtensionContext["ui"]["custom"]>) => {
      const [factory, options] = args;
      const wrappedFactory: typeof factory = async (...factoryArgs) => {
        const component = await factory(...factoryArgs);
        const originalRender = component.render.bind(component);
        let notified = false;

        component.render = (width: number) => {
          const lines = originalRender(width);
          const message = notified ? undefined : customUiNotificationMessage(lines);
          if (message) {
            notified = true;
            process.stdout.write(osc777Notification(message, "warning"));
          }
          return lines;
        };

        return component;
      };

      return originalCustom(wrappedFactory, options);
    }) as ExtensionContext["ui"]["custom"];
    ui[PATCHED_CUSTOM] = true;
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
}
