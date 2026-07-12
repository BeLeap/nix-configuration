# Pi setup recommendations

Reviewed the current Nix-managed Pi setup and Pi 0.80.5 documentation. Existing setup already covers model cycling, Context7, MCP, notifications, sandboxing, web access, custom theme, and shared AGENTS.md instructions.

Recommended next priorities:

1. Keep core policy/settings declarative, but account for `~/.pi/agent/settings.json` being Home Manager-managed: interactive `/settings`, `pi install`, and `pi config` may be unable to persist changes. Use Nix for permanent changes and temporary CLI flags for experiments, or introduce a deliberate mutable/local settings layer if desired.
2. Set `defaultThinkingLevel` (suggested `medium`) so sessions start consistently.
3. Set `externalEditor` to the preferred editor command with a wait flag.
4. Keep `defaultProjectTrust = "ask"`; use `/trust` per known repository rather than globally trusting projects.
5. Consider `enableInstallTelemetry = false` and `PI_SKIP_VERSION_CHECK=1` if privacy/reproducibility is preferred. These are independent controls.
6. Consider `PI_CACHE_RETENTION=long` only when longer provider prompt caching is worth its provider-specific cost/retention implications.
7. Add a few personal prompt templates (review, debug, handoff) before adding more third-party packages.
8. Do not add more extensions by default; the current package set is already broad and every package/extension has full user-level execution capability.
