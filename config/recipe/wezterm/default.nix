_: {
  darwin = {
    system = [
      ({pkgs, ...}: {
        system.defaults.dock.persistent-apps = [
          {app = "${pkgs.wezterm-upstream}/Applications/WezTerm.app";}
        ];
      })
    ];
  };
  home = [
    ({
      lib,
      pkgs,
      ...
    }: let
      weztermConfig = pkgs.writeText "wezterm.lua" (
        builtins.replaceStrings ["@zsh@"] ["${lib.getExe pkgs.zsh}"] (builtins.readFile ./wezterm.lua)
      );
    in {
      home.packages = [
        pkgs.wezterm-upstream
      ];

      xdg.configFile."wezterm/wezterm.lua".source = weztermConfig;
    })
  ];
}
