{ lib, pkgs, ... }:
{
  programs.starship = {
    enable = true;

    enableZshIntegration = true;

    settings =
      lib.recursiveUpdate
        (
          with builtins;
          (fromTOML (readFile "${pkgs.starship}/share/starship/presets/bracketed-segments.toml"))
        )
        {
          right_format = "$kubernetes";

          kubernetes.disabled = false;
        };
  };
}
