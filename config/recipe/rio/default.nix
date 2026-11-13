_: let
  mkDarwinRio = pkgs: let
    rio = pkgs.unstable.rio;
  in
    pkgs.runCommand "rio-${rio.version}" {
      inherit (rio) meta version;
      pname = "rio";
    } ''
      mkdir -p "$out"
      cp -a ${rio}/. "$out/"
      chmod u+w "$out/Applications/Rio.app/Contents/MacOS"
      rm "$out/Applications/Rio.app/Contents/MacOS/rio"
      cp -p ${rio}/bin/rio "$out/Applications/Rio.app/Contents/MacOS/rio"
    '';
in {
  darwin = {
    system = [
      ({
        inputs,
        pkgs,
        ...
      }: let
        rioPackage = mkDarwinRio pkgs;
        rio = (import inputs.nix-mac-app-identity {inherit pkgs;}).stabilizeApp rioPackage;
      in {
        system.defaults.dock.persistent-apps = [
          {app = "${rio}/Applications/Rio.app";}
        ];
      })
    ];
  };

  darwin.home = [
    ({pkgs, ...}: {
      targets.darwin.appIdentity.apps = [(mkDarwinRio pkgs)];
    })
  ];

  home = [
    ({
      host,
      lib,
      pkgs,
      ...
    }: let
      rioConfig = (pkgs.formats.toml {}).generate "rio-config.toml" {
        colors = {
          background = "#282828";
          foreground = "#ebdbb2";
          black = "#282828";
          red = "#cc241d";
          green = "#98971a";
          yellow = "#d79921";
          blue = "#458588";
          magenta = "#b16286";
          cyan = "#689d6a";
          white = "#a89984";
          "light-black" = "#928374";
          "light-red" = "#fb4934";
          "light-green" = "#b8bb26";
          "light-yellow" = "#fabd2f";
          "light-blue" = "#83a598";
          "light-magenta" = "#d3869b";
          "light-cyan" = "#8ec07c";
          "light-white" = "#ebdbb2";
        };
        fonts = {
          family = "Hanadia Mono";
          size = 16.0;
        };
        navigation.mode = "Plain";
        window.mode = "Maximized";
        panel.padding = [
          0
          8
        ];
        shell = {
          program = lib.getExe pkgs.zellij;
          args = [
            "attach"
            "--create"
            "sp"
          ];
        };
      };
    in {
      home.packages = lib.optionals (host.backend != "darwin") [pkgs.unstable.rio];
      xdg.configFile."rio/config.toml".source = rioConfig;
    })
  ];
}
