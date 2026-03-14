{
  metadata,
  agenix,
  ...
}: {
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
      home.activation.copyFiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
        mkdir -p $HOME/.agents/skills
        rm -rf $HOME/.agents/skills/joplin-cli
        cp -R ${./skills/joplin-cli} $HOME/.agents/skills/joplin-cli
      '';

      programs.joplin-desktop = {
        enable = true;
        sync = {
          target = "onedrive";
        };
      };
    })
  ];
}
