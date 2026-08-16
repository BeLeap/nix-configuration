{
  agenix,
  llm-agents,
  metadata,
  ...
}: {
  hm = [
    (
      {
        config,
        pkgs,
        ...
      }: let
        torpiLauncherSource = pkgs.replaceVars ./torpi-launcher.mjs {
          curl = "${pkgs.curl}/bin/curl";
          privoxy = "${pkgs.privoxy}/bin/privoxy";
          privoxyConfigDir = "${pkgs.privoxy}/etc";
          tor = "${pkgs.tor}/bin/tor";
        };
        pi = pkgs.symlinkJoin {
          name = "pi";
          paths = [llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi];
          nativeBuildInputs = [pkgs.makeWrapper];
          postBuild = ''
            wrapProgram $out/bin/pi \
              --set PI_SKIP_VERSION_CHECK 1 \
              --prefix PATH : ${pkgs.lib.makeBinPath [pkgs.ripgrep]} \
              --run 'export CONTEXT7_API_KEY="$(${pkgs.coreutils}/bin/cat ${config.age.secrets."context7-api-key".path})"'
          '';
        };
        torpi = pkgs.writeShellScriptBin "torpi" ''
          exec ${pkgs.nodejs}/bin/node ${torpiLauncherSource} ${pi}/bin/pi "$@"
        '';
      in {
        imports = [(import ../../../lib/agenix/hm.nix {inherit agenix metadata;})];

        age.secrets = {
          context7-api-key.file = ./secrets/context7-api-key.age;
        };

        home = {
          packages = [
            pi
            torpi
          ];

          file = {
            ".pi/agent/AGENTS.md".source = ../../../files/AGENTS.md;
            ".pi/agent/settings.json".text = builtins.toJSON {
              defaultProvider = "openai-codex";
              defaultModel = "gpt-5.6-luna";
              defaultThinkingLevel = "max";
              defaultProjectTrust = "ask";
              enableInstallTelemetry = false;
              theme = "gruvbox";
              enabledModels = [
                "gpt-5.6-sol"
                "gpt-5.6-terra"
                "gpt-5.6-luna"
                "gpt-5.5"
                "gpt-5.4"
                "gpt-5.3-codex-spark"
                "openrouter/z-ai/glm-5.2"
                "ollama/qwen3.5:9b"
              ];
              packages = [
                "https://github.com/ayghri/i-have-adhd"
                "npm:@upstash/context7-pi"
                "npm:pi-btw"
                "npm:pi-chrome"
                "npm:pi-mcp-adapter"
                "npm:pi-notify"
                "npm:pi-permission-modes"
                "npm:pi-web-access"
                "npm:context-mode"
                "https://github.com/tmustier/pi-queue-steer"
                "npm:pi-title-renamer"
              ];
            };
            ".pi/agent/models.json".text = builtins.toJSON {
              providers = {
                ollama = {
                  baseUrl = "http://beleap-macmini:11434/v1";
                  api = "openai-completions";
                  apiKey = "ollama";
                  compat = {
                    supportsDeveloperRole = false;
                    supportsReasoningEffort = false;
                    maxTokensField = "max_tokens";
                  };
                  models = [
                    {
                      id = "qwen3.5:9b";
                      name = "Qwen3.5 9B (beleap-macmini)";
                      reasoning = false;
                      input = ["text" "image"];
                      contextWindow = 8192;
                      maxTokens = 4096;
                      samplingParams = {
                        reasoning_effort = "none";
                      };
                      cost = {
                        input = 0;
                        output = 0;
                        cacheRead = 0;
                        cacheWrite = 0;
                      };
                    }
                  ];
                };
              };
            };
            ".pi/agent/permission-mode/permission-mode.json".text = builtins.toJSON (import ./permission-mode.nix);
            ".pi/agent/extensions/notify-osc.ts".source = ./notify-osc.ts;
            ".pi/agent/extensions/tor-status.ts".source = ./tor-status.ts;
            ".pi/agent/themes/gruvbox.json".source = ./gruvbox.json;
          };
        };
      }
    )
  ];
}
