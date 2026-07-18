import { spawn, type ChildProcessByStdio } from "node:child_process";
import { mkdir, mkdtemp, rm } from "node:fs/promises";
import type { Readable } from "node:stream";
import { createServer } from "node:net";
import { tmpdir } from "node:os";
import { join } from "node:path";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { createLocalBashOperations, isToolCallEventType } from "@earendil-works/pi-coding-agent";

const TOR_BIN = "@tor@";
const TORSOCKS_BIN = "@torsocks@";
const BASH_BIN = "@bash@";
const ENV_BIN = "@env@";
const STATE_ENTRY = "tor-shell-state";
const STATUS_KEY = "tor-shell";
const BOOTSTRAP_TIMEOUT_MS = 120_000;

type TorRuntime = {
  process: ChildProcessByStdio<null, Readable, Readable>;
  port: number;
  dataDirectory: string;
};

type PersistedState = { enabled: boolean };

function shellQuote(value: string): string {
  return `'${value.replace(/'/g, `'"'"'`)}'`;
}

function injectableShell(shell = process.env.SHELL): string {
  // macOS SIP strips torsocks' DYLD injection when it launches an Apple system shell.
  return shell && !shell.startsWith("/bin/") && !shell.startsWith("/usr/bin/") ? shell : BASH_BIN;
}

function wrapCommand(command: string, port: number, shell = process.env.SHELL): string {
  const wrappedShell = injectableShell(shell);
  return [
    "exec",
    shellQuote(ENV_BIN),
    "TORSOCKS_TOR_ADDRESS=127.0.0.1",
    `TORSOCKS_TOR_PORT=${port}`,
    shellQuote(TORSOCKS_BIN),
    "--isolate",
    shellQuote(wrappedShell),
    "-c",
    shellQuote(command),
  ].join(" ");
}

async function reservePort(): Promise<number> {
  return new Promise((resolve, reject) => {
    const server = createServer();
    server.once("error", reject);
    server.listen(0, "127.0.0.1", () => {
      const address = server.address();
      if (!address || typeof address === "string") {
        server.close();
        reject(new Error("Tor setup failed: could not reserve a local SOCKS port."));
        return;
      }

      const { port } = address;
      server.close((error) => (error ? reject(error) : resolve(port)));
    });
  });
}

async function terminate(runtime: TorRuntime): Promise<void> {
  if (runtime.process.exitCode === null && runtime.process.signalCode === null) {
    runtime.process.kill("SIGTERM");
    await Promise.race([
      new Promise<void>((resolve) => runtime.process.once("close", () => resolve())),
      new Promise<void>((resolve) => setTimeout(resolve, 5_000)),
    ]);

    if (runtime.process.exitCode === null && runtime.process.signalCode === null) {
      runtime.process.kill("SIGKILL");
      await new Promise<void>((resolve) => runtime.process.once("close", () => resolve()));
    }
  }

  await rm(runtime.dataDirectory, { recursive: true, force: true });
}

async function launchTor(): Promise<TorRuntime> {
  const root = join(tmpdir(), "pi-tor");
  await mkdir(root, { recursive: true, mode: 0o700 });
  const dataDirectory = await mkdtemp(join(root, "session-"));
  const port = await reservePort();
  const child = spawn(
    TOR_BIN,
    [
      "--ClientOnly",
      "1",
      "--SocksPort",
      `127.0.0.1:${port}`,
      "--DataDirectory",
      dataDirectory,
      "--Log",
      "notice stdout",
    ],
    { stdio: ["ignore", "pipe", "pipe"] },
  );
  const runtime = { process: child, port, dataDirectory };

  try {
    await new Promise<void>((resolve, reject) => {
      const logLines: string[] = [];
      let buffered = "";
      let settled = false;
      let timeout: NodeJS.Timeout | undefined;

      const cleanup = () => {
        if (timeout) clearTimeout(timeout);
        child.stdout.off("data", remember);
        child.stderr.off("data", remember);
        child.off("error", onError);
        child.off("close", onClose);
      };
      const succeed = () => {
        if (settled) return;
        settled = true;
        cleanup();
        resolve();
      };
      const fail = (message: string) => {
        if (settled) return;
        settled = true;
        cleanup();
        const logs = [...logLines, buffered].filter(Boolean).join("\n");
        reject(new Error(logs ? `${message}\n${logs}` : message));
      };
      const remember = (chunk: Buffer) => {
        buffered += chunk.toString();
        const lines = buffered.split("\n");
        buffered = lines.pop() ?? "";
        for (const line of lines) {
          logLines.push(line);
          if (logLines.length > 20) logLines.shift();
          if (line.includes("Bootstrapped 100%")) succeed();
        }
      };
      const onError = (error: Error) => fail(`Failed to start Tor: ${error.message}`);
      const onClose = (code: number | null, signal: NodeJS.Signals | null) =>
        fail(`Tor exited before bootstrapping (code ${code ?? "none"}, signal ${signal ?? "none"}).`);

      child.stdout.on("data", remember);
      child.stderr.on("data", remember);
      child.once("error", onError);
      child.once("close", onClose);
      timeout = setTimeout(
        () => fail(`Tor did not bootstrap within ${BOOTSTRAP_TIMEOUT_MS / 1000} seconds.`),
        BOOTSTRAP_TIMEOUT_MS,
      );
    });
    return runtime;
  } catch (error) {
    await terminate(runtime);
    throw error;
  }
}

function restoreEnabled(ctx: ExtensionContext): boolean {
  let enabled = false;
  for (const entry of ctx.sessionManager.getBranch()) {
    if (entry.type === "custom" && entry.customType === STATE_ENTRY) {
      enabled = (entry.data as Partial<PersistedState> | undefined)?.enabled === true;
    }
  }
  return enabled;
}

export default function (pi: ExtensionAPI) {
  let runtime: TorRuntime | undefined;
  let startup: Promise<TorRuntime> | undefined;

  const updateStatus = (ctx: ExtensionContext) => {
    if (runtime) {
      ctx.ui.setStatus(STATUS_KEY, ctx.ui.theme.fg("accent", `Tor:${runtime.port}`));
    } else if (startup) {
      ctx.ui.setStatus(STATUS_KEY, ctx.ui.theme.fg("warning", "Tor:starting"));
    } else {
      ctx.ui.setStatus(STATUS_KEY, undefined);
    }
  };

  const enable = async (ctx: ExtensionContext): Promise<void> => {
    if (runtime) return;
    const bashOwner = pi.getAllTools().find((tool) => tool.name === "bash")?.sourceInfo.path;
    if (bashOwner?.includes("pi-landstrip") && pi.getFlag("no-sandbox") !== true) {
      throw new Error(
        "pi-landstrip owns bash and its network proxy cannot safely compose with torsocks. " +
          "Restart Pi with --no-sandbox before enabling Tor routing.",
      );
    }
    if (!startup) {
      startup = launchTor();
      updateStatus(ctx);
    }

    try {
      const started = await startup;
      runtime = started;
      started.process.stdout.resume();
      started.process.stderr.resume();
      started.process.on("error", (error) => console.error(`[tor-shell] Tor process error: ${error.message}`));
      started.process.once("close", async (code, signal) => {
        if (runtime?.process !== started.process) return;
        runtime = undefined;
        updateStatus(ctx);
        try {
          await rm(started.dataDirectory, { recursive: true, force: true });
        } catch (error) {
          const message = error instanceof Error ? error.message : String(error);
          ctx.ui.notify(`Failed to clean up Tor data directory: ${message}`, "error");
        }
        ctx.ui.notify(
          `Tor routing stopped unexpectedly (code ${code ?? "none"}, signal ${signal ?? "none"}).`,
          "error",
        );
      });
      ctx.ui.notify(`Tor routing enabled for shell commands on SOCKS port ${runtime.port}.`, "info");
    } finally {
      startup = undefined;
      updateStatus(ctx);
    }
  };

  const disable = async (ctx: ExtensionContext): Promise<void> => {
    if (startup) {
      runtime = await startup;
      startup = undefined;
    }
    if (runtime) {
      const current = runtime;
      runtime = undefined;
      await terminate(current);
    }
    updateStatus(ctx);
    ctx.ui.notify("Tor routing disabled for shell commands.", "info");
  };

  pi.on("tool_call", (event) => {
    const port = runtime?.port;
    if (port && isToolCallEventType("bash", event)) {
      event.input.command = wrapCommand(event.input.command, port);
    }
  });

  pi.on("user_bash", () => {
    const port = runtime?.port;
    if (!port) return;

    const local = createLocalBashOperations();
    return {
      operations: {
        exec(command, cwd, options) {
          return local.exec(wrapCommand(command, port), cwd, options);
        },
      },
    };
  });

  pi.registerFlag("tor", {
    description: "Route shell-command TCP and DNS traffic through a session-scoped Tor client.",
    type: "boolean",
    default: false,
  });

  pi.on("session_start", async (_event, ctx) => {
    const shouldEnable = pi.getFlag("tor") === true || restoreEnabled(ctx);
    if (!shouldEnable) return;

    try {
      await enable(ctx);
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      ctx.ui.notify(`Tor routing failed: ${message}`, "error");
    }
  });

  pi.registerCommand("tor", {
    description: "Toggle Tor routing for agent bash and user ! commands (on|off|status).",
    getArgumentCompletions: (prefix) => {
      const options = ["on", "off", "status"];
      const matches = options.filter((option) => option.startsWith(prefix));
      return matches.length ? matches.map((value) => ({ value, label: value })) : null;
    },
    handler: async (args, ctx) => {
      const action = args.trim().toLowerCase() || (runtime ? "off" : "on");
      if (action === "status") {
        const status = runtime ? `enabled on SOCKS port ${runtime.port}` : startup ? "starting" : "disabled";
        ctx.ui.notify(`Tor shell routing is ${status}. Model provider traffic is unaffected.`, "info");
        return;
      }
      if (action !== "on" && action !== "off") {
        ctx.ui.notify("Usage: /tor [on|off|status]", "error");
        return;
      }

      try {
        if (action === "on") {
          await enable(ctx);
          pi.appendEntry(STATE_ENTRY, { enabled: true } satisfies PersistedState);
        } else {
          await disable(ctx);
          pi.appendEntry(STATE_ENTRY, { enabled: false } satisfies PersistedState);
        }
      } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        ctx.ui.notify(`Tor routing failed: ${message}`, "error");
      }
    },
  });

  pi.on("session_shutdown", async () => {
    if (runtime) {
      const current = runtime;
      runtime = undefined;
      await terminate(current);
    }
  });
}
