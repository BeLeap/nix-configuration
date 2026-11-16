{host, ...}: {
  darwin = {
    system = [
      (_: {
        system.defaults.dock.persistent-apps = [
          {app = "/Users/${host.usernameLower}/Applications/Home Manager Apps/WezTerm.app";}
        ];
      })
    ];
  };
  darwin.home = [
    ({pkgs, ...}: {
      targets.darwin.appIdentity.apps = [pkgs.wezterm-upstream];
    })
  ];
  home = [
    ({
      host,
      lib,
      pkgs,
      ...
    }: let
      weztermConfig = pkgs.writeText "wezterm.lua" (
        builtins.replaceStrings ["@zsh@"] ["${lib.getExe pkgs.zsh}"] (builtins.readFile ./wezterm.lua)
      );
    in {
      home.packages = lib.optionals (host.backend != "darwin") [pkgs.wezterm-upstream];

      xdg.configFile."wezterm/wezterm.lua".source = weztermConfig;
    })
  ];
}
