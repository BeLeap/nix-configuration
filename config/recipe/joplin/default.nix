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
        joplin-settings = {
          file = ./secrets/joplin-settings.age;
          path = "${config.home.homeDirectory}/.config/joplin/settings.json";
        };
      };

      home.packages = with pkgs; [
        joplin-terminal
      ];

      programs.joplin-desktop = {
        enable = true;
        sync = {
          target = "onedrive";
        };
      };
    })
  ];
}
