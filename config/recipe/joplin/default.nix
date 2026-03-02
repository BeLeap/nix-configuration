_: {
  hm = [
    ({pkgs, ...}: {
      home.packages = with pkgs; [
        joplin-cli
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
