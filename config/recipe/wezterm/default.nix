{
  lib,
  metadata,
}: let
  useBrew = metadata.distribution == "macos" && metadata.kind != "airgap";
in {
  base = [
    (lib.optionalAttrs useBrew {
      homebrew = {
        casks = ["wezterm"];
      };
    })
  ];
  hm = [
    (
      {
        pkgs,
        lib,
        ...
      }: {
        programs.wezterm = {
          enable = true;

          package =
            if useBrew
            then pkgs.wezterm-null
            else pkgs.wezterm;

          enableBashIntegration = true;
          enableZshIntegration = true;

          extraConfig = builtins.readFile (pkgs.replaceVars ./config.lua {
            TMUX = "${lib.getExe pkgs.tmux}";
          });
        };
      }
    )
  ];
}
