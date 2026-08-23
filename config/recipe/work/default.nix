_: {
  home = [
    ({pkgs, ...}: {
      home.packages = with pkgs; [
        unstable.jira-cli-go
      ];
    })
  ];

  darwin = {
    system = [
      (_: {
        system.defaults.dock.persistent-apps = [
          {app = "/Applications/IntelliJ IDEA.app";}
          {app = "/Applications/DataGrip.app";}
        ];
      })
    ];
  };
}
