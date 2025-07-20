{ pkgs, ... }:
{
  programs.ghostty.enable = !pkgs.stdenv.isDarwin;
}
