_: {
  hm = [
    (
      {metadata, ...}: {
        programs.nh = {
          enable = true;
          flake = "/Users/${metadata.usernameLower}/nix-configuration#darwinConfigurations.${metadata.name}";

          clean = {
            enable = true;
          };
        };
      }
    )
  ];
}
