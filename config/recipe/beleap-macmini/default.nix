_: {
  base = _: {
    homebrew = {
      brews = [
        "mlx-lm"
        "googleworkspace-cli"
      ];
      casks = [
        "gcloud-cli"
      ];
    };
  };

  hm = [
    ({pkgs, ...}: {
      home.packages = with pkgs; [
        isync
      ];
      launchd.agents = {
        mlx-lm = {
          enable = true;
          config = {
            Program = "/opt/homebrew/bin/mlx_lm.server";
            ProgramArguments = [
              "--model"
              "mlx-community/gemma-4-e4b-it-8bit"
              "--prompt-cache-size"
              "2"
              "--prompt-cache-bytes"
              "2GB"
            ];
            KeepAlive = true;
            RunAtLoad = true;
            StandardOutPath = "/tmp/mlx-lm.out.log";
            StandardErrorPath = "/tmp/mlx-lm.err.log";
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
