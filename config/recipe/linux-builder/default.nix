_: {
  darwin.system = [
    (_: {
      nix.linux-builder = {
        enable = true;
        ephemeral = true;

        config.virtualisation.darwin-builder.diskSize = 64 * 1024;
      };
    })
  ];
}
