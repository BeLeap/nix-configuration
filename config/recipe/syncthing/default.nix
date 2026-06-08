_: {
  hm = [
    ({config, ...}: {
      services.syncthing = {
        enable = true;

        settings = {
          folders = {
            "${config.home.homeDirectory}/Sync" = {
              id = "sync";
            };
          };
        };
      };
    })
  ];
}
