_: {
  hm = [
    (
      {pkgs, ...}: {
        home = {
          packages = [pkgs.llm-agents.pi];

          file = {
            ".pi/agent/AGENTS.md".source = ../../../files/AGENTS.md;

            ".pi/agent/settings.json".text = builtins.toJSON {
              defaultProvider = "openai-codex";
              defaultModel = "gpt-5.5";
              theme = "gruvbox";
            };

            ".pi/agent/themes/gruvbox.json".source = ./gruvbox.json;
          };
        };
      }
    )
  ];
}
