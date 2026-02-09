{ lib, metadata }:
{
  base = [
    (lib.optionalAttrs (metadata.distribution == "macos") {
      homebrew = {
        casks = [ "wezterm" ];
      };
    })
  ];
  hm = [
    (
      { pkgs, ... }:
      {
        programs.wezterm = {
          enable = true;

          package = (if (metadata.distribution == "macos") then pkgs.wezterm-null else pkgs.wezterm);

          enableBashIntegration = true;
          enableZshIntegration = true;

          extraConfig = builtins.readFile ./config.lua;
        };
      }
    )
  ];
}
