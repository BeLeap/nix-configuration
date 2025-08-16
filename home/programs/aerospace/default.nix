_: {
  programs.aerospace = {
    enable = true;

    launchd = {
      enable = true;
      keepAlive = true;
    };

    userSettings = {
      key-mapping = {
        preset = "colemak";
      };
    };
  };
}
