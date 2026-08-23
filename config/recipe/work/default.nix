_: {
  homeModules = [
    ({pkgs, ...}: {
      home.packages = with pkgs; [
        unstable.jira-cli-go
      ];
    })
  ];
}
