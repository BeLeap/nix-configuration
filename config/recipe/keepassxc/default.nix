_: {
  hm = [
    (_: {
      programs.keepassxc = {
        enable = true;

        settings = {
          GUI = {
            LaunchAtStartup = true;
            MinimizeToTray = true;
            MinimizeOnStartup = true;
            MinimizeOnClose = true;
            CheckForUpdates = false;
            HidePasswords = true;
          };
          Browser = {
            Enabled = true;
            AlwaysAllowAccess = true;
          };
          SSHAgent.Enabled = true;
        };
      };
    })
  ];
}
