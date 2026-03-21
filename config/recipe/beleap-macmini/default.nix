_: {
  base = _: {
    homebrew = {
      brews = ["zeroclaw" "ollama"];
    };
  };

  hm = [
    (_: {
      launchd.agents = {
        zeroclaw = {
          enable = true;
          config = {
            Program = "/opt/homebrew/bin/zeroclaw";
            ProgramArguments = ["daemon" "--host" "0.0.0.0" "--port" "80"];
            KeepAlive = true;
            RunAtLoad = true;
            StandardOutPath = "/tmp/zeroclaw.log";
            StandardErrorPath = "/tmp/zeroclaw.log";
          };
        };
        ollama = {
          enable = true;
          config = {
            Program = "/opt/homebrew/bin/ollama";
            ProgramArguments = ["serve"];
            KeepAlive = true;
            RunAtLoad = true;
            StandardOutPath = "/tmp/ollama.log";
            StandardErrorPath = "/tmp/ollama.log";
          };
        };
      };
    })
  ];
}
