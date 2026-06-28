_: {
  base = _: {
    homebrew = {
      enable = true;

      onActivation = {
        # nix-darwin 26.05 currently renders cleanup = "zap" as the removed
        # Homebrew Bundle --force-cleanup flag. Keep zap cleanup enabled with
        # Homebrew's supported flags until the pinned nix-darwin input is fixed.
        cleanup = "none";
        extraFlags = ["--cleanup" "--zap" "--verbose"];
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
