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
            ProgramArguments = ["--model" "mlx-community/Qwen3.5-2B-4bit"];
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
