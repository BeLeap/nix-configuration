{ pkgs, ... }:
{
  # Installed using brew on macOS
  programs.ghostty.enable = !pkgs.stdenv.isDarwin;
}
