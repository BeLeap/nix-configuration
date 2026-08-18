import type {
  ExtensionAPI,
  ExtensionContext,
} from "@earendil-works/pi-coding-agent";
import { execFileSync } from "node:child_process";

const PATCHED_NOTIFY = Symbol.for("beleap.notify-osc.patched");
const PATCHED_SELECT = Symbol.for("beleap.notify-osc.select-patched");
const PATCHED_CUSTOM = Symbol.for("beleap.notify-osc.custom-render-patched.v3");
const OSC = "\x1b]";
const BEL = "\x07";

type NotifyLevel = "info" | "warning" | "error";
type WezTermPane = {
  pane_id?: number;
  workspace?: string;
};
type PatchableUi = ExtensionContext["ui"] & {
  [PATCHED_NOTIFY]?: boolean;
  [PATCHED_SELECT]?: boolean;
  [PATCHED_CUSTOM]?: boolean;
};

function sanitizeOscField(value: string): string {
  return value.replace(/[\x00-\x1f\x7f;]/g, " ").trim();
}

function weztermWorkspace(): string | undefined {
  const paneId = process.env.WEZTERM_PANE;
  if (!paneId) {
    return undefined;
  }

  try {
    const output = execFileSync(
      "wezterm",
      ["cli", "list", "--format", "json"],
      {
        encoding: "utf8",
      },
    );
    const panes: unknown = JSON.parse(output);
    if (!Array.isArray(panes)) {
      throw new Error("wezterm cli list returned a value that is not an array");
    }

    const pane = (panes as WezTermPane[]).find(
      ({ pane_id }) => String(pane_id) === paneId,
    );
    if (!pane) {
      throw new Error(
        `pane ${paneId} was not present in wezterm cli list output`,
      );
    }
    if (typeof pane.workspace !== "string" || !pane.workspace.trim()) {
      throw new Error(`pane ${paneId} did not have a workspace name`);
    }

    return pane.workspace;
  } catch (error) {
    const detail = error instanceof Error ? error.message : String(error);
    process.stderr.write(
      `notify-osc: failed to determine WezTerm workspace: ${detail}\n`,
    );
    return undefined;
  }
}

function osc777Notification(message: string): string {
  const body = sanitizeOscField(message);
  const workspace = weztermWorkspace();
  const title = sanitizeOscField(workspace ? `Pi (${workspace})` : "Pi");

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
            process.stdout.write(
              osc777Notification(customUiNotificationMessage(lines)),
            );
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
