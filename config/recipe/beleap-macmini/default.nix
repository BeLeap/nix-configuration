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
        unstable.python313Packages.mlx-vlm
      ];
      launchd.agents = {
        ml-self-hosted = {
          enable = true;
          config = {
            Program = "${pkgs.unstable.python313Packages.mlx-vlm}/bin/mlx_vlm.server";
            ProgramArguments = [
              "--model"
              "mlx-community/gemma-4-e4b-it-mxfp4"
            ];
            KeepAlive = true;
            RunAtLoad = true;
            StandardOutPath = "/tmp/ml-self-hosted.out.log";
            StandardErrorPath = "/tmp/ml-self-hosted.err.log";
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
