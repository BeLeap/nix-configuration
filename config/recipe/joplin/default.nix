{
  metadata,
  agenix,
  ...
}: let
  installStoreDirScript = import ../../../lib/hm/install-store-dir-script.nix;
in {
  hm = [
    ({
      config,
      pkgs,
      lib,
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
      home.activation.copyFiles = lib.hm.dag.entryAfter ["writeBoundary"] (
        installStoreDirScript {
          source = ./skills/joplin-cli;
          targetRelativePath = ".agents/skills/joplin-cli";
        }
      );

      programs.joplin-desktop = {
        enable = true;
        sync = {
          target = "onedrive";
        };
      };
      xdg.configFile."joplin-desktop/plugins".source = ./desktop-plugins;
    })
  ];
}
