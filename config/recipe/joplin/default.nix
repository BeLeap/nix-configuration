{
  metadata,
  agenix,
  ...
}: {
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
        joplin-settings.file = ./secrets/joplin-settings.age;
      };

      home.packages = with pkgs; [
        joplin-terminal
      ];
      home.file.".config/joplin/settings.json" = {
        source =
          config.lib.file.mkOutOfStoreSymlink
          config.age.secrets."joplin-settings".path;
        force = true;
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
