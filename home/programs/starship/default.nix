{ lib, pkgs, ... }:
{
  programs.starship = {
    enable = true;

    enableZshIntegration = true;
    enableBashIntegration = true;

    settings =
      lib.recursiveUpdate
        (
          with builtins;
          (fromTOML (readFile "${pkgs.starship}/share/starship/presets/bracketed-segments.toml"))
        )
        {
          right_format = "$kubernetes";

          kubernetes.disabled = false;

          shlvl.disabled = false;
          shlvl.threshold = 3;
          shlvl.format = "\\[[$shlvl]($style)\\]";

          os.disabled = false;
        };
  };
}
