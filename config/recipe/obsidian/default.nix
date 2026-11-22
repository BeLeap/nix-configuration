_: {
  darwin = {
    home = [
      (_: {
        programs.obsidian = {
          enable = true;
          vaults.personal = {
            enable = true;
            target = "Sync/Personal";
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
