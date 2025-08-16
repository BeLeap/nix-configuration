_: {
  programs.aerospace = {
    enable = true;

    launchd = {
      enable = true;
      keepAlive = true;
    };

    userSettings = {
      key-mapping = {
        # NOTE: use colemak after home-manager fixes
        preset = "dvorak";
      };
    };
  };
}
