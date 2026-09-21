{
  inputs,
  host,
  ...
}: {
  home = [
    ({
      config,
      pkgs,
      ...
    }: {
      imports = [
        (import ../../../lib/agenix/hm.nix {inherit inputs host;})
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
      home.file.".agents/skills/joplin-cli".source = ./skills/joplin-cli;

      programs.joplin-desktop = {
        enable = true;
        package = pkgs.unstable.joplin-desktop;
        sync = {
          target = "onedrive";
        };
      };
      xdg.configFile."joplin-desktop/plugins".source = ./desktop-plugins;
    })
  ];

  darwin = {
    system = [
      ({pkgs, ...}: {
        system.defaults.dock.persistent-apps = [
          {app = "${pkgs.unstable.joplin-desktop}/Applications/Joplin.app";}
        ];
      })
    ];
  };
}
