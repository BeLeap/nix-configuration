_: {
  darwin = {
    home = [
      (
        {host, ...}: {
          programs.nh = {
            enable = true;
            flake = "/Users/${host.usernameLower}/nix-configuration#darwinConfigurations.${host.name}";

            clean = {
              enable = true;
            };
          };
        }
      )
    ];
  };

  nixos = {
    home = [
      (
        {host, ...}: {
          programs.nh = {
            enable = true;
            flake = "/home/${host.usernameLower}/nix-configuration#nixosConfigurations.${host.name}";

            clean = {
              enable = true;
            };
          };
        }
      )
    ];
  };
}
