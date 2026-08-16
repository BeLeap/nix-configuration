# Replace the Mac mini VLM service with Ollama

- Removed the Mac mini recipe's `mlx-lm`, `mlx-vlm`, Gemma VLM, and `ml-self-hosted` launchd configuration.
- Added the Homebrew `ollama` formula and a launchd agent running `ollama serve` on `127.0.0.1:11434`.
- Configured one parallel request, one loaded model, an 8K default context, and disabled Ollama cloud features.
- The recommended model still needs to be pulled on the Mac after applying the recipe: `ollama pull qwen3.5:9b`.

Validation:

- `nix-instantiate --parse config/recipe/beleap-macmini/default.nix` passed.
- Confirmed no VLM-related references remain in the host recipe.
- `alejandra --check` was unavailable in the current environment.

Update:

- Added `ollamaModel = "qwen3.5:9b"` to the recipe.
- Home Manager now runs an idempotent `ollama pull` after the Ollama LaunchAgent is set up, waiting up to 60 seconds for the local API.
- The model no longer needs a separate manual pull after switching the configuration.

Correction:

- Reverted the activation-time model pull because coupling Home Manager activation to a network-dependent Ollama operation was unnecessarily invasive.
- The recipe only manages the Ollama server; model downloads remain an explicit `ollama pull qwen3.5:9b` step.
