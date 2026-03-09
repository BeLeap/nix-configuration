_: {
  hm = [
    ({pkgs, ...}: {
      home.packages = with pkgs; [
        joplin-terminal
      ];
      programs.joplin-desktop = {
        enable = true;
        sync = {
          target = "onedrive";
        };
      };
    })
  ];
}
