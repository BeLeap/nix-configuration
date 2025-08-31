{ metadata, pkgs, ... }:
{
  programs.wezterm = {
    enable = true;

    package = if metadata.os == "macos" then pkgs.wezterm-null else pkgs.wezterm;

    enableBashIntegration = true;
    enableZshIntegration = true;

    extraConfig = builtins.readFile ./config.lua;
  };
}
