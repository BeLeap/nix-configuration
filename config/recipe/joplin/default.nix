{
  metadata,
  agenix,
}: {
  hm = [
    ({pkgs, ...}: {
      import = [
        ../../../lib/agenix/hm.nix
        {inherit agenix metadata;}
      ];
      age.secrets = {
        joplin-api-token.file = ./secrets/joplin-api-token.age;
      };

      home.packages = with pkgs; [
        joplin-terminal
      ];
      home.file.".config/joplin/settings.json".text = builtins.toJSON {
        altInstanceId = "";
        "sync.target" = 3;
        locale = "en_US";
        "markdown.plugin.softbreaks" = false;
        "markdown.plugin.typographer" = false;
        "api.token" = "";
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
