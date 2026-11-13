_: {
  home = [
    ({
      config,
      lib,
      pkgs,
      ...
    }: let
      reloadPlugin = import ./reload-config.nix {inherit pkgs;};
      zellijConfig = pkgs.writeText "zellij-config.kdl" (
        builtins.replaceStrings
        ["@zsh@" "@reload-config-plugin@" "@nvim@"]
        [
          (lib.getExe pkgs.zsh)
          "file:${reloadPlugin}/share/zellij/plugins/config-reloader.wasm"
          (lib.getExe config.programs.nixvim.build.package)
        ]
        (builtins.readFile ./config.kdl)
      );
    in {
      home.packages = [pkgs.unstable.zellij];
      home.sessionVariables.ZELLIJ_SOCKET_DIR = "\${TMPDIR%/}/zellij-\${UID}";
      xdg.configFile."zellij/config.kdl".source = zellijConfig;
    })
  ];
}
