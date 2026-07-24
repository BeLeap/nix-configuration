import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const PATCHED_NOTIFY = Symbol.for("beleap.notify-osc.patched");
const PATCHED_SELECT = Symbol.for("beleap.notify-osc.select-patched");
const PATCHED_CUSTOM = Symbol.for("beleap.notify-osc.custom-render-patched.v3");
const OSC = "\x1b]";
const BEL = "\x07";

type NotifyLevel = "info" | "warning" | "error";
type PatchableUi = ExtensionContext["ui"] & {
  [PATCHED_NOTIFY]?: boolean;
  [PATCHED_SELECT]?: boolean;
  [PATCHED_CUSTOM]?: boolean;
};

function sanitizeOscField(value: string): string {
  return value.replace(/[\x00-\x1f\x7f;]/g, " ").trim();
}

function osc777Notification(message: string): string {
  const body = sanitizeOscField(message);

  return `${OSC}777;notify;Pi;${body}${BEL}`;
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
      process.stdout.write(osc777Notification(message));
    };
    ui[PATCHED_NOTIFY] = true;
  }

  if (!ui[PATCHED_SELECT]) {
    const originalSelect = ui.select.bind(ui);

    ui.select = ((...args: Parameters<ExtensionContext["ui"]["select"]>) => {
      const [title] = args;
      process.stdout.write(osc777Notification(title));
      return originalSelect(...args);
    }) as ExtensionContext["ui"]["select"];
    ui[PATCHED_SELECT] = true;
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
          if (!notified) {
            notified = true;
            process.stdout.write(osc777Notification(customUiNotificationMessage(lines)));
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

  pi.registerCommand("notify-osc-select-test", {
    description: "Test OSC notification forwarding for ctx.ui.select.",
    handler: async (_args, ctx) => {
      patchUi(ctx);
      await ctx.ui.select("OSC select UI test", ["Close"]);
    },
  });
}
