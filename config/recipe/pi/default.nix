{
  agenix,
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
        pi = pkgs.symlinkJoin {
          name = "pi";
          paths = [pkgs.llm-agents.pi];
          nativeBuildInputs = [pkgs.makeWrapper];
          postBuild = ''
            wrapProgram $out/bin/pi \
              --run 'export CONTEXT7_API_KEY="$(${pkgs.coreutils}/bin/cat ${config.age.secrets."context7-api-key".path})"'
          '';
        };
      in {
        imports = [(import ../../../lib/agenix/hm.nix {inherit agenix metadata;})];

        age.secrets = {
          context7-api-key.file = ../opencode/secrets/context7-api-key.age;
        };

        home = {
          packages = [
            pi
          ];

          file = {
            ".pi/agent/AGENTS.md".source = ../../../files/AGENTS.md;
            ".pi/agent/settings.json".text = builtins.toJSON {
              defaultProvider = "openai-codex";
              defaultModel = "gpt-5.6-sol";
              theme = "gruvbox";
              enabledModels = [
                "gpt-5.6-sol"
                "gpt-5.6-terra"
                "gpt-5.6-luna"
                "gpt-5.5"
                "gpt-5.4"
                "gpt-5.3-codex-spark"
                "openrouter/z-ai/glm-5.2"
              ];
              packages = [
                "npm:@upstash/context7-pi@0.1.1"
                "npm:pi-mcp-adapter@2.11.0"
                "npm:pi-notify@1.4.0"
                "npm:pi-landstrip@0.16.29"
              ];
            };
            ".pi/agent/themes/gruvbox.json".source = ./gruvbox.json;
          };
        };
      }
    )
  ];
}
