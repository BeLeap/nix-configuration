_: {
  base = _: {
    homebrew = {
      enable = true;

      onActivation = {
        cleanup = "zap";
        extraFlags = ["--verbose"];
      };

      taps = [];
      brews = ["mas"];
      casks = [
        "meetingbar"
        "karabiner-elements"
        "wireshark-chmodbpf"
        "gureumkim"
      ];
      masApps = {};
    };
  };
}
