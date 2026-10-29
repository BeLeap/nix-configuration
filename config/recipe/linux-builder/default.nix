_: {
  darwin.system = [
    (_: {
      nix.linux-builder = {
        enable = true;
        ephemeral = true;
        systems = [
          "aarch64-linux"
          "x86_64-linux"
        ];

        config = {
          boot.binfmt.emulatedSystems = ["x86_64-linux"];
          virtualisation.darwin-builder.diskSize = 64 * 1024;
        };
      };
    })
  ];
}
