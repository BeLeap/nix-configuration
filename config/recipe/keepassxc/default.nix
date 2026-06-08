_: {
  hm = [
    (_: {
      programs.keepassxc = {
        enable = true;

        settings = {
          Browser.Enabled = true;
          GUI = {
            HidePasswords = true;
          };
          SSHAgent.Enabled = true;
        };
      };
    })
  ];
}
