# Disable Qwen3.5 reasoning for ZeroClaw

- Added `runtime.reasoning_enabled = false` to the declarative ZeroClaw config rendered by `config/recipe/beleap-macmini/default.nix`.
- This prevents Ollama/Qwen3.5 from entering its default reasoning path that previously produced incomplete tool-call output and HTTP 500 `{"error":"EOF"}` responses.
- Validation passed:
  - `nix-instantiate --parse config/recipe/beleap-macmini/default.nix`
  - Evaluated `darwinConfigurations.beleap-macmini.config.system.build.toplevel.drvPath`
  - Evaluated `darwinConfigurations.beleap-m1air.config.system.build.toplevel.drvPath`
- `alejandra --check` was unavailable in the current shell.
- Applying the configuration still requires the normal Darwin activation on the Mac mini; no live service restart was performed here.
