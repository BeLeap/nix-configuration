import { lstatSync, realpathSync } from "node:fs";
import { homedir } from "node:os";
import { basename, dirname, relative, resolve, sep } from "node:path";
import { fileURLToPath } from "node:url";

function normalizePath(input: string): string | null {
  let value = input.startsWith("@") ? input.slice(1) : input;

  try {
    if (value.startsWith("file://")) value = fileURLToPath(value);
  } catch {
    return null;
  }

  if (value === "~") value = homedir();
  else if (value.startsWith("~/")) value = resolve(homedir(), value.slice(2));

  return value;
}

function canonicalizeTarget(target: string): string | null {
  let current = target;
  const missingParts: string[] = [];

  while (true) {
    let stat;
    try {
      stat = lstatSync(current);
    } catch (error) {
      if ((error as NodeJS.ErrnoException).code !== "ENOENT") return null;

      const parent = dirname(current);
      if (parent === current) return null;
      missingParts.unshift(basename(current));
      current = parent;
      continue;
    }

    if (stat.isSymbolicLink()) {
      try {
        return resolve(realpathSync(current), ...missingParts);
      } catch {
        return null;
      }
    }

    try {
      return resolve(realpathSync(current), ...missingParts);
    } catch {
      return null;
    }
  }
}

function isWithinProject(projectRoot: string, target: string): boolean {
  const fromProject = relative(projectRoot, target);
  return fromProject === "" || (fromProject !== ".." && !fromProject.startsWith(`..${sep}`));
}

export default function (pi: any) {
  pi.on("tool_call", (event: any, ctx: any) => {
    if (event.toolName !== "write" && event.toolName !== "edit") return;

    const rawPath = event.input?.path;
    if (typeof rawPath !== "string") {
      return {block: true, reason: "A file path is required for writes."};
    }

    const normalizedPath = normalizePath(rawPath);
    if (!normalizedPath) {
      return {block: true, reason: "The write path could not be resolved safely."};
    }

    try {
      const projectRoot = realpathSync(ctx.cwd);
      const target = canonicalizeTarget(resolve(projectRoot, normalizedPath));
      if (target && isWithinProject(projectRoot, target)) return;
    } catch {
      // Fail closed if the project root or target cannot be resolved.
    }

    return {
      block: true,
      reason: "Pi file writes are restricted to the project directory.",
    };
  });
}
