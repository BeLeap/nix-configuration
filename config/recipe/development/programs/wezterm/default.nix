{ pkgs, ... }:
{
  programs.wezterm = {
    enable = true;

    package = pkgs.unstable.wezterm;

    enableBashIntegration = true;
    enableZshIntegration = true;

    extraConfig = builtins.readFile ./config.lua;
  };
}
