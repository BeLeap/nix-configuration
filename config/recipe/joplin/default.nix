{
  metadata,
  agenix,
  lib,
  ...
}: let
  installStoreDir = import ../../../lib/hm/install-store-dir.nix {inherit lib;};
in {
  hm = [
    ({
      config,
      pkgs,
      ...
    }: {
      imports = [
        (import ../../../lib/agenix/hm.nix {inherit agenix metadata;})
      ];
      age.secrets = {
        joplin-settings = {
          file = ./secrets/joplin-settings.age;
          path = "${config.home.homeDirectory}/.config/joplin/settings.json";
        };
      };

      home.packages = with pkgs; [
        joplin-terminal
      ];
      home.activation.copyFiles = installStoreDir {
        source = ./skills/joplin-cli;
        targetRelativePath = ".agents/skills/joplin-cli";
      };

      programs.joplin-desktop = {
        enable = true;
        sync = {
          target = "onedrive";
        };
      };
    })
  ];
}
