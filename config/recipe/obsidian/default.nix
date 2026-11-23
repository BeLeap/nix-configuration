_: {
  darwin = {
    home = [
      (_: {
        programs.obsidian = {
          enable = true;
          vaults.personal = {
            enable = true;
            target = "Sync/Personal";
            settings.extraFiles."daily-notes.json".text = builtins.toJSON {
              folder = "01_Journal";
            };
          };
        };
      })
    ];
    system = [
      ({pkgs, ...}: {
        system.defaults.dock.persistent-apps = [
          {app = "${pkgs.obsidian}/Applications/Obsidian.app";}
        ];
      })
    ];
  };
}
