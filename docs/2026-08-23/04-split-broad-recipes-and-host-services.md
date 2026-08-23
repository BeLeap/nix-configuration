# Enhancement 4: Split broad recipes and extract host services

## Goal

Make baseline recipes communicate intent and keep concrete host recipes small. Separate reusable Ollama and ZeroClaw service implementations from the Mac mini’s host-specific settings.

Estimated implementation time: **4–7 hours**, split into recipe-composition and service-extraction revisions.

All declarations in this enhancement remain ordinary recipes. Terms such as “baseline,” “role,” and “capability” describe intended use, not separate types or directory layers.

## Part A: Split the broad default recipe

### Current problem

The current `default` recipe includes infrastructure and workstation policy together:

- overlay and Home Manager integration;
- base system configuration;
- Nix and agenix;
- the full development recipe;
- Firefox;
- Kubernetes tooling.

As a result, every host receives a broad development/desktop baseline, including headless VM and work configurations. The name `default` does not explain that policy.

### Target recipes

Create explicit composition recipes with one reason to change:

```text
core          # assembly foundation, user baseline, Nix, secrets support
development   # editors, shells, VCS, language and debugging tools
desktop       # graphical shared applications such as Firefox
kubernetes    # Kubernetes-specific tools
```

A `core` recipe may keep common behavior in `system` and `home`, with actual platform differences in its `nixos` and `darwin` fragments. Do not create separate platform recipe names solely because their module implementations differ.

### Behavior-preserving migration

The first revision must preserve behavior:

1. create the new recipes;
2. make every host select the recipes corresponding to its existing `default` expansion;
3. remove `default` only after before/after expansion comparison passes.

Removing Firefox, Kubernetes, qBittorrent, or development tools from a host is a policy change. Make those removals in later atomic revisions with explicit host intent and validation.

### Recipe-split acceptance criteria

- No recipe named `default` hides workstation policy.
- `core` contains only configuration required by nearly every host.
- Development, desktop, and Kubernetes selections are visible in host roots or broader role-oriented recipes.
- The new composition recipes have no special loader behavior or directory namespace.
- The initial split does not change effective packages or services.
- Later policy reductions are isolated and documented.

## Part B: Extract Ollama and ZeroClaw from the Mac mini host

### Current problem

`config/recipe/beleap-macmini/default.nix` contains:

- Homebrew package selection;
- complete Ollama LaunchAgent implementation and environment;
- ZeroClaw runtime TOML generation;
- Discord token-file waiting and validation logic;
- ZeroClaw LaunchAgent implementation;
- host-specific model and port values.

This mixes reusable service behavior with one machine’s choices and makes service changes appear host-specific.

### Target recipes

Create separate recipes, for example:

```text
config/recipe/ollama/default.nix
config/recipe/zeroclaw/default.nix
config/recipe/local-ai/default.nix
```

The Ollama recipe may contribute its Homebrew system module through `darwin.system` and its Home Manager LaunchAgent through `darwin.home`. The ZeroClaw recipe contributes through `darwin.home`. `local-ai` may include both recipes when selecting the pair is useful.

Do not combine Ollama and ZeroClaw implementations into one recipe. Each service needs an independent option namespace and lifecycle, while a broader ordinary recipe may compose them.

Suggested option boundaries:

```nix
beleap.services.ollama = {
  enable = true;
  command = "/opt/homebrew/bin/ollama";
  host = "0.0.0.0:11434";
  contextLength = 32768;
  parallelRequests = 1;
  maxLoadedModels = 1;
  cloud.enable = false;
};

beleap.services.zeroclaw = {
  enable = true;
  model = "qwen3.5:4b";
  providerUrl = "http://127.0.0.1:11434";
  gatewayPort = 42617;
  discordTokenFile = "...";
};
```

Use typed `lib.mkOption` declarations with descriptions and safe defaults. Add assertions for invalid states, such as ZeroClaw enabled without a non-empty token path or with a publicly bound gateway while public binding is disabled.

### Preserve operational behavior

- Keep explicit failure for an empty Discord token.
- Preserve private file permissions and atomic runtime-config replacement.
- Preserve the current token wait behavior unless changed in a separate operational revision.
- Do not add network-dependent model pulls to Home Manager activation. Prior work explicitly reverted that coupling.
- Preserve current LaunchAgent restart and environment behavior.
- Do not silently fall back to another provider or model.

The Mac mini recipe should end with only host choices: recipe selection and option values.

### Service acceptance criteria

- Ollama and ZeroClaw implementations live in separate reusable recipes outside the Mac mini recipe.
- Each service recipe can be selected and configured independently.
- Options are typed and invalid combinations produce actionable assertions.
- The host recipe contains no generated TOML body or daemon shell implementation.
- Generated ZeroClaw configuration retains private permissions and token handling.
- No activation-time model download is introduced.
- The Mac mini configuration evaluates successfully.

## Validation

Run the global checks from [README.md](README.md). Before extraction, capture relevant evaluated values or generated files; after extraction, compare:

- Homebrew brews;
- Ollama and ZeroClaw LaunchAgent attributes;
- executable paths and arguments;
- environment variables;
- generated ZeroClaw TOML excluding store-path-only differences;
- token-file and state-directory paths.

Also evaluate the two other Darwin hosts to prove the new service recipes do not activate globally.

## Non-goals

- Do not change the selected Ollama model during extraction.
- Do not redesign secret storage in the same revision.
- Do not move logs or alter network binding as an incidental cleanup.
- Do not remove packages from hosts during the behavior-preserving recipe split.
