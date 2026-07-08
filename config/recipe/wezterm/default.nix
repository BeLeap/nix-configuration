_: {
  hm = [
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
        pkgs.wezterm
      ];

      xdg.configFile."wezterm/wezterm.lua".source = weztermConfig;
    })
  ];
}
