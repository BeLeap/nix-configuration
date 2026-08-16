_: {
  base = _: {
    homebrew = {
      brews = [
        "googleworkspace-cli"
        "ollama"
      ];
    };
  };

  hm = [
    ({pkgs, ...}: {
      home.packages = with pkgs; [
        isync
      ];
      launchd.agents.ollama = {
        enable = true;
        config = {
          Program = "/opt/homebrew/bin/ollama";
          ProgramArguments = ["serve"];
          KeepAlive = true;
          RunAtLoad = true;
          StandardOutPath = "/tmp/ollama.out.log";
          StandardErrorPath = "/tmp/ollama.err.log";
          EnvironmentVariables = {
            OLLAMA_HOST = "127.0.0.1:11434";
            OLLAMA_CONTEXT_LENGTH = "8192";
            OLLAMA_NUM_PARALLEL = "1";
            OLLAMA_MAX_LOADED_MODELS = "1";
            OLLAMA_NO_CLOUD = "1";
          };
        };
      };
    })
  ];
}
