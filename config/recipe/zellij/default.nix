_: {
  home = [
    ({
      lib,
      pkgs,
      ...
    }: let
      zellijConfig = pkgs.writeText "zellij-config.kdl" (
        builtins.replaceStrings ["@zsh@"] [(lib.getExe pkgs.zsh)] (builtins.readFile ./config.kdl)
      );
    in {
      home.packages = [pkgs.unstable.zellij];
      home.sessionVariables.ZELLIJ_SOCKET_DIR = "\${TMPDIR%/}/zellij-\${UID}";
      xdg.configFile."zellij/config.kdl".source = zellijConfig;
    })
  ];
}
