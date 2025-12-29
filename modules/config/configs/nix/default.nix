{
  common = {
    config =
      { ... }:
      {
        nix.optimise.automatic = true;

        nixpkgs = {
          config.allowUnfree = true;
        };

        # Necessary for using flakes on this system.
        nix.settings = {
          trusted-users = [ "@admin" ];
          experimental-features = "nix-command flakes";
          min-free = "1M";
        };

        nix.gc = {
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
      };
  };
  macos = {
    config =
      { ... }:
      {
        nix.linux-builder = {
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
  };
}
