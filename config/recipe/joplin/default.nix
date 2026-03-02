_: {
  hm = [
    (_: {
      programs.joplin-desktop = {
        enable = true;
        sync = {
          target = "onedrive";
        };
      };
    })
  ];
}
