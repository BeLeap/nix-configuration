_: {
  hm = [
    ({pkgs, ...}: {
      home.packages = with pkgs; [
        unstable.jira-cli-go
      ];
    })
  ];
}
