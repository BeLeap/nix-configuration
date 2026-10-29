_: {
  darwin = {
    system = [
      ({
        inputs,
        pkgs,
        ...
      }: let
        wezterm = (import inputs.nix-mac-app-identity {inherit pkgs;}).stabilizeApp pkgs.wezterm-upstream;
      in {
        system.defaults.dock.persistent-apps = [
          {app = "${wezterm}/Applications/WezTerm.app";}
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
      home.packages = lib.optionals (!(lib.hasSuffix "-darwin" host.platform)) [pkgs.wezterm-upstream];

      xdg.configFile."wezterm/wezterm.lua".source = weztermConfig;
    })
  ];
}
