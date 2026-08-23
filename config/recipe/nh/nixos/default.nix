_: {
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
