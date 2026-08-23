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
}
