{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;

    # Installed using brew on macOS
    package = if pkgs.stdenv.isDarwin then null else pkgs.ghostty;

    settings = {
      theme = "catppuccin-frappe";

      # Use package meta someday...
      font-family = [
        "Cascadia Code NF"
	"NanumGothicCoding"
      ];
      font-feature = "'calt', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'ss09', 'liga'";
      font-size = 18;

      window-padding-x = 10;
      window-title-font-family = "Cascadia Code NF";
      # Clamped to screen size so below works as maxmized
      window-height = 99999;
      window-width = 99999;

      shell-integration-features = "no-title";
    };
  };
}
