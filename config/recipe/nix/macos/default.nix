_: {
  base = [
    {
      nix = {
        gc = {
          automatic = true;
          interval = [
            {
              Hour = 3;
              Minute = 15;
              Weekday = 7;
            }
          ];
          options = "--delete-older-than 3d";
        };

        linux-builder = {
          enable = true;
          ephemeral = true;

          config = {
            virtualisation = {
              darwin-builder = {
                diskSize = 64 * 1024;
              };
            };
          };
        };
      };
    }
  ];
}
