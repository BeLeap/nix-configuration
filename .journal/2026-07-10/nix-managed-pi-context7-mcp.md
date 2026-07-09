# Nix-managed Context7 MCP for pi

- Added a pi extension under the pi recipe via Home Manager, at `~/.pi/agent/extensions/context7-mcp`.
- The extension is generated from Nix and talks MCP over stdio to a Nix-managed `pkgs.context7-mcp` wrapper.
- The wrapper reads the existing agenix-managed Context7 API key and fails explicitly if the key is missing.
- Removed the earlier unmanaged `~/.pi/agent/extensions/context7-mcp` directory to avoid Home Manager activation conflicts.
- Refactored the extension into `config/recipe/pi/context7-mcp.ts` and use `pkgs.replaceVars` from `config/recipe/pi/default.nix` to inject the Nix-built MCP wrapper path.
- Verified the generated extension builds and contains the substituted store path.
