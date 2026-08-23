_: {
  home = [
    ({pkgs, ...}: {
      home.packages = with pkgs; [
        unstable.jira-cli-go
      ];
    })
  ];
}
