# Use llm-agents direct package output

Switched Pi from the llm-agents nixpkgs overlay to the flake's direct package output. The upstream README recommends `llm-agents.packages.${pkgs.stdenv.hostPlatform.system}` because those packages use the pinned, CI-tested nixpkgs revision and can use Numtide's binary cache. Removed the llm-agents overlay and now wrap `llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi` directly.

Validation: Alejandra formatting passed. Full flake evaluation and build were blocked because the execution sandbox denied access to the Nix daemon socket; this was an environment restriction rather than a Nix evaluation failure.
