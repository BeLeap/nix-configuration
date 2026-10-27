import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const STATUS_KEY = "session-id";

export default function (pi: ExtensionAPI) {
  pi.on("session_start", (_event, ctx) => {
    const sessionId = ctx.sessionManager.getSessionId();
    ctx.ui.setStatus(STATUS_KEY, ctx.ui.theme.fg("dim", `sid: ${sessionId}`));
  });

  pi.on("session_shutdown", (_event, ctx) => {
    ctx.ui.setStatus(STATUS_KEY, undefined);
  });
}
