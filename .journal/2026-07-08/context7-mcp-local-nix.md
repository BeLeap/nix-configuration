# Context7 MCP Local Nix Package

- Updated `config/recipe/opencode/default.nix` to use opencode's local MCP transport for Context7.
- Replaced the remote `https://mcp.context7.com/mcp` server with a Nix-managed wrapper around `pkgs.context7-mcp`.
- Restored the existing agenix-managed Context7 API key and pass it to `context7-mcp --api-key` at runtime.
- Kept the API key out of `opencode.json`; the wrapper reads the decrypted age secret and fails clearly if it is missing.
- Verified `pkgs.context7-mcp` exists in nixpkgs 26.05 and exposes `context7-mcp` as `meta.mainProgram`.
