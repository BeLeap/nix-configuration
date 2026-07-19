import { spawn } from "node:child_process";
import { mkdir, mkdtemp, rm, writeFile } from "node:fs/promises";
import { createConnection, createServer } from "node:net";
import { homedir, tmpdir } from "node:os";
import { join } from "node:path";

const TOR_BIN = "@tor@";
const PRIVOXY_BIN = "@privoxy@";
const PRIVOXY_CONFIG_DIR = "@privoxyConfigDir@";
const CURL_BIN = "@curl@";
const SANDBOX_EXEC_BIN = "/usr/bin/sandbox-exec";
const STARTUP_TIMEOUT_MS = 120_000;
const CHECK_URL = "https://check.torproject.org/api/ip";
const PROXY_VARIABLES = [
  "HTTP_PROXY",
  "HTTPS_PROXY",
  "ALL_PROXY",
  "http_proxy",
  "https_proxy",
  "all_proxy",
];

function fatal(message) {
  console.error(`[torpi] ${message}`);
  process.exitCode = 1;
}

function cleanEnvironment(environment = process.env) {
  const result = { ...environment };
  for (const name of [
    ...PROXY_VARIABLES,
    "NO_PROXY",
    "no_proxy",
    "DYLD_INSERT_LIBRARIES",
    "TORSOCKS_TOR_ADDRESS",
    "TORSOCKS_TOR_PORT",
    "TORSOCKS_ISOLATE_PID",
  ]) {
    delete result[name];
  }
  return result;
}

async function reservePort() {
  const server = createServer();
  await new Promise((resolve, reject) => {
    server.once("error", reject);
    server.listen(0, "127.0.0.1", resolve);
  });
  const address = server.address();
  if (!address || typeof address === "string") {
    server.close();
    throw new Error("Could not reserve a local TCP port.");
  }
  await new Promise((resolve, reject) => server.close((error) => (error ? reject(error) : resolve())));
  return address.port;
}

function rememberLines(lines, chunk) {
  for (const line of chunk.toString().split("\n")) {
    if (!line) continue;
    lines.push(line);
    if (lines.length > 30) lines.shift();
  }
}

async function startTor(dataDirectory, cacheDirectory, port) {
  const child = spawn(
    TOR_BIN,
    [
      "--ClientOnly",
      "1",
      "--SocksPort",
      `127.0.0.1:${port}`,
      "--DataDirectory",
      dataDirectory,
      "--CacheDirectory",
      cacheDirectory,
      "--Log",
      "notice stdout",
    ],
    { env: cleanEnvironment(), stdio: ["ignore", "pipe", "pipe"] },
  );
  const logs = [];

  try {
    await new Promise((resolve, reject) => {
      let bootstrapOutput = "";
      let settled = false;
      const timeout = setTimeout(
        () => finish(new Error(`Tor did not bootstrap within ${STARTUP_TIMEOUT_MS / 1000} seconds.`)),
        STARTUP_TIMEOUT_MS,
      );
      const finish = (error) => {
        if (settled) return;
        settled = true;
        clearTimeout(timeout);
        child.stdout.off("data", onData);
        child.stderr.off("data", onData);
        child.off("error", onError);
        child.off("close", onClose);
        error ? reject(error) : resolve();
      };
      const onData = (chunk) => {
        const text = chunk.toString();
        bootstrapOutput = `${bootstrapOutput}${text}`.slice(-4096);
        rememberLines(logs, chunk);
        for (const line of text.split("\n")) {
          if (line.includes("Bootstrapped ")) console.error(`[torpi] ${line.replace(/^.*Bootstrapped /, "Bootstrapped ")}`);
        }
        if (bootstrapOutput.includes("Bootstrapped 100%")) finish();
      };
      const onError = (error) => finish(new Error(`Failed to start Tor: ${error.message}`));
      const onClose = (code, signal) =>
        finish(new Error(`Tor exited before bootstrapping (code ${code ?? "none"}, signal ${signal ?? "none"}).`));
      child.stdout.on("data", onData);
      child.stderr.on("data", onData);
      child.once("error", onError);
      child.once("close", onClose);
    });
  } catch (error) {
    child.kill("SIGTERM");
    const details = logs.length ? `\n${logs.join("\n")}` : "";
    throw new Error(`${error instanceof Error ? error.message : String(error)}${details}`);
  }

  child.stdout.resume();
  child.stderr.resume();
  return child;
}

async function waitForListener(child, port) {
  const deadline = Date.now() + 10_000;
  while (Date.now() < deadline) {
    if (child.exitCode !== null || child.signalCode !== null) {
      throw new Error(`Privoxy exited during startup (code ${child.exitCode ?? "none"}, signal ${child.signalCode ?? "none"}).`);
    }
    const connected = await new Promise((resolve) => {
      const socket = createConnection({ host: "127.0.0.1", port });
      socket.once("connect", () => {
        socket.destroy();
        resolve(true);
      });
      socket.once("error", () => resolve(false));
    });
    if (connected) return;
    await new Promise((resolve) => setTimeout(resolve, 50));
  }
  throw new Error("Privoxy did not start listening within 10 seconds.");
}

async function startPrivoxy(root, torPort, proxyPort) {
  const configPath = join(root, "privoxy.conf");
  await writeFile(
    configPath,
    [
      `confdir ${PRIVOXY_CONFIG_DIR}`,
      `logdir ${root}`,
      `listen-address  127.0.0.1:${proxyPort}`,
      `forward-socks5t / 127.0.0.1:${torPort} .`,
      "toggle  1",
      "enable-remote-toggle  0",
      "enable-edit-actions  0",
      "",
    ].join("\n"),
    { mode: 0o600 },
  );
  const child = spawn(PRIVOXY_BIN, ["--no-daemon", configPath], {
    env: cleanEnvironment(),
    stdio: ["ignore", "pipe", "pipe"],
  });
  const logs = [];
  child.stdout.on("data", (chunk) => rememberLines(logs, chunk));
  child.stderr.on("data", (chunk) => rememberLines(logs, chunk));
  try {
    await waitForListener(child, proxyPort);
  } catch (error) {
    child.kill("SIGTERM");
    const details = logs.length ? `\n${logs.join("\n")}` : "";
    throw new Error(`${error instanceof Error ? error.message : String(error)}${details}`);
  }
  return child;
}

async function runCapture(command, args, options = {}) {
  return new Promise((resolve, reject) => {
    const child = spawn(command, args, { ...options, stdio: ["ignore", "pipe", "pipe"] });
    let stdout = "";
    let stderr = "";
    child.stdout.on("data", (chunk) => (stdout += chunk));
    child.stderr.on("data", (chunk) => (stderr += chunk));
    child.once("error", reject);
    child.once("close", (code, signal) => resolve({ code, signal, stdout, stderr }));
  });
}

async function verifyTor(proxyUrl) {
  const result = await runCapture(
    CURL_BIN,
    ["--proxy", proxyUrl, "--fail", "--silent", "--show-error", "--max-time", "30", CHECK_URL],
    { env: cleanEnvironment() },
  );
  if (result.code !== 0) {
    throw new Error(`Tor verification request failed: ${result.stderr.trim() || `curl exited ${result.code}`}`);
  }
  let response;
  try {
    response = JSON.parse(result.stdout);
  } catch {
    throw new Error(`Tor verification returned invalid JSON: ${result.stdout.trim()}`);
  }
  if (response?.IsTor !== true) {
    throw new Error("Tor verification reported that the proxy exit is not a Tor relay.");
  }
}

async function stop(child) {
  if (!child || child.exitCode !== null || child.signalCode !== null) return;
  child.kill("SIGTERM");
  await new Promise((resolve) => {
    const onClose = () => {
      clearTimeout(timeout);
      resolve();
    };
    const timeout = setTimeout(() => {
      child.off("close", onClose);
      resolve();
    }, 5_000);
    child.once("close", onClose);
  });
  if (child.exitCode === null && child.signalCode === null) child.kill("SIGKILL");
}

function waitForClose(name, child) {
  if (child.exitCode !== null || child.signalCode !== null) {
    return Promise.resolve({ name, code: child.exitCode, signal: child.signalCode });
  }
  return new Promise((resolve) =>
    child.once("close", (code, signal) => resolve({ name, code, signal })),
  );
}

async function main() {
  if (process.platform !== "darwin") throw new Error("Strict Pi Tor containment is currently supported only on macOS.");
  const [piExecutable, ...piArguments] = process.argv.slice(2);
  if (!piExecutable) throw new Error("Missing Pi executable argument.");

  const root = await mkdtemp(join(tmpdir(), "torpi-"));
  let tor;
  let privoxy;
  let pi;
  let signalToRaise;
  let shuttingDown = false;
  const signalHandlers = new Map();
  for (const signal of ["SIGINT", "SIGTERM", "SIGHUP"]) {
    const handler = () => {
      if (shuttingDown) return;
      shuttingDown = true;
      signalToRaise = signal;
      if (pi?.exitCode === null && pi.signalCode === null) pi.kill(signal);
    };
    signalHandlers.set(signal, handler);
    process.on(signal, handler);
  }

  try {
    const torPort = await reservePort();
    const proxyPort = await reservePort();
    const cacheDirectory = join(homedir(), "Library", "Caches", "pi-tor");
    await mkdir(cacheDirectory, { recursive: true, mode: 0o700 });
    console.error("[torpi] Starting a dedicated Tor circuit...");
    tor = await startTor(join(root, "tor-data"), cacheDirectory, torPort);
    privoxy = await startPrivoxy(root, torPort, proxyPort);
    const proxyUrl = `http://127.0.0.1:${proxyPort}`;
    await verifyTor(proxyUrl);
    console.error("[torpi] Tor route verified; starting fail-closed Pi sandbox.");

    const profilePath = join(root, "pi.sb");
    await writeFile(
      profilePath,
      [
        "(version 1)",
        "(allow default)",
        "(deny network-outbound)",
        `(allow network-outbound (remote tcp "localhost:${proxyPort}"))`,
        "",
      ].join("\n"),
      { mode: 0o600 },
    );

    const environment = cleanEnvironment();
    for (const name of PROXY_VARIABLES) environment[name] = proxyUrl;
    environment.NO_PROXY = "";
    environment.no_proxy = "";
    environment.PI_TOR_ACTIVE = "1";
    environment.PI_TOR_HTTP_PROXY = proxyUrl;
    environment.PI_TOR_SOCKS_PORT = String(torPort);

    const effectiveArguments = piArguments.some(
      (argument) => argument === "--no-sandbox" || argument === "--no-sandbox=true",
    )
      ? piArguments
      : [...piArguments, "--no-sandbox"];

    pi = spawn(SANDBOX_EXEC_BIN, ["-f", profilePath, piExecutable, ...effectiveArguments], {
      env: environment,
      stdio: "inherit",
    });
    const outcome = await Promise.race([
      waitForClose("pi", pi),
      waitForClose("Tor", tor),
      waitForClose("Privoxy", privoxy),
    ]);
    if (outcome.name !== "pi" && !shuttingDown) {
      console.error(
        `[torpi] ${outcome.name} stopped unexpectedly (code ${outcome.code ?? "none"}, signal ${outcome.signal ?? "none"}).`,
      );
      shuttingDown = true;
      await stop(pi);
      process.exitCode = 1;
    } else {
      signalToRaise ??= outcome.signal ?? undefined;
      process.exitCode = outcome.code ?? (signalToRaise ? 0 : 1);
    }
  } finally {
    shuttingDown = true;
    await stop(pi);
    await stop(privoxy);
    await stop(tor);
    await rm(root, { recursive: true, force: true });
    for (const [signal, handler] of signalHandlers) process.off(signal, handler);
  }

  if (signalToRaise) process.kill(process.pid, signalToRaise);
}

main().catch((error) => fatal(error instanceof Error ? error.message : String(error)));
