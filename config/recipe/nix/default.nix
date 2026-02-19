{ lib, metadata }:
{
  base = [
    {
      nix.optimise.automatic = true;

      nixpkgs = {
        config.allowUnfree = true;
        config.android_sdk.accept_license = true;
      };

      nix.settings = {
        trusted-users = [ "@admin" ];
        experimental-features = "nix-command flakes";
        min-free = "1M";
        accept-flake-config = true;
      };

      nix.gc =
        { }
        // lib.optionalAttrs (metadata.distribution == "nixos") {
          dates = "weekly";
        }
        // lib.optionalAttrs (metadata.distribution == "macos") {
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
    }
    (lib.optionalAttrs (metadata.distribution == "macos") {
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
    })
  ];
}
