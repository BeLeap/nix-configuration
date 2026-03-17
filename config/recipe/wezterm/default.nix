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
      {pkgs, ...}: {
        programs.wezterm = {
          enable = true;

          package =
            if useBrew
            then pkgs.wezterm-null
            else pkgs.wezterm;

          enableBashIntegration = true;
          enableZshIntegration = true;

          extraConfig = builtins.readFile ./config.lua;
        };
      }
    )
  ];
}
