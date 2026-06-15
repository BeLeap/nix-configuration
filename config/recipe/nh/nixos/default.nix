_: {
  hm = [
    (
      {metadata, ...}: {
        programs.nh = {
          enable = true;
          flake = "/home/${metadata.usernameLower}/nix-configuration#nixosConfigurations.${metadata.name}";

          clean = {
            enable = true;
          };
        };
      }
    )
  ];
}
