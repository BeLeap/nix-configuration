_: {
  home = [
    (_: {
      home.file.".pi/agent/auto-model.json".text = builtins.toJSON {
        enabled = true;
        constraints.modelInclude = [
          "openai/gpt-6-luna"
          "openrouter/z-ai/glm-5.2"
          "ollama/qwen3.5:4b"
        ];
      };
    })
  ];
}
