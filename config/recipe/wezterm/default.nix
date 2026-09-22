_: {
  darwin = {
    system = [
      ({pkgs, ...}: {
        system.defaults.dock.persistent-apps = [
          {app = "${pkgs.wezterm}/Applications/WezTerm.app";}
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
        (
          if pkgs.stdenv.isDarwin
          then pkgs.wezterm-dmg
          else pkgs.wezterm
        )
      ];

      xdg.configFile."wezterm/wezterm.lua".source = weztermConfig;
    })
  ];
}
