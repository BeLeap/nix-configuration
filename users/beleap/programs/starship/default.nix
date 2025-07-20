{ pkgs, ... }:
{
  programs.starship = {
    enable = true;

    enableZshIntegration = true;

    settings =
      with builtins;
      (fromTOML (readFile "${pkgs.starship}/share/starship/presets/bracketed-segments.toml"));
  };
}
