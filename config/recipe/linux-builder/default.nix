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
          nix.gc = {
            automatic = true;
            dates = "daily";
          };
          boot.binfmt.emulatedSystems = ["x86_64-linux"];
          virtualisation.darwin-builder = {
            diskSize = 64 * 1024;
            min-free = 8 * 1024 * 1024 * 1024;
            max-free = 16 * 1024 * 1024 * 1024;
          };
        };
      };
    })
  ];
}
