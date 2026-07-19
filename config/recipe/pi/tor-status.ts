import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const STATUS_KEY = "tor";

function torActive(): boolean {
  return process.env.PI_TOR_ACTIVE === "1";
}

function proxyDescription(): string {
  return process.env.PI_TOR_HTTP_PROXY ?? "unknown local proxy";
}

export default function (pi: ExtensionAPI) {
  pi.on("session_start", (_event, ctx) => {
    if (torActive()) {
      ctx.ui.setStatus(STATUS_KEY, ctx.ui.theme.fg("accent", "Tor:contained"));
      ctx.ui.notify(`All outbound traffic is contained through Tor via ${proxyDescription()}.`, "info");
    } else {
      ctx.ui.setStatus(STATUS_KEY, undefined);
    }
  });

  pi.registerCommand("tor", {
    description: "Show strict Tor containment status.",
    handler: async (args, ctx) => {
      if (args.trim()) {
        ctx.ui.notify("Usage: /tor", "error");
        return;
      }

      const status = torActive()
        ? `enabled and fail-closed via ${proxyDescription()}`
        : "disabled; start torpi for a contained session";
      ctx.ui.notify(`Tor containment is ${status}.`, torActive() ? "info" : "warning");
    },
  });

  pi.on("session_shutdown", (_event, ctx) => {
    ctx.ui.setStatus(STATUS_KEY, undefined);
  });
}
