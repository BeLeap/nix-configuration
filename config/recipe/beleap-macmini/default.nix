_: {
  base = _: {
    homebrew = {
      brews = [
        "ollama"
        "googleworkspace-cli"
      ];
    };
  };

  hm = [
    (_: {
      launchd.agents = {
        ollama = {
          enable = true;
          config = {
            Program = "/opt/homebrew/bin/ollama";
            ProgramArguments = ["serve"];
            KeepAlive = true;
            RunAtLoad = true;
            StandardOutPath = "/tmp/ollama.out.log";
            StandardErrorPath = "/tmp/ollama.err.log";
            EnvironmentVariables = {
              OLLAMA_NUM_PARALLEL = "1";
              OLLAMA_MAX_LOADED_MODELS = "1";
            };
          };
        };
      };
    })
  ];
}
