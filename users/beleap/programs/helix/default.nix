{ pkgs, ... }:
{
  programs.helix = {
    enable = true;

    defaultEditor = true;

    settings = {
      theme = "catppuccin_frappe";

      editor = import ./editor.nix;
    };

    languages = {
      language-server = import ./language-servers.nix { inherit pkgs; };
      language = import ./languages.nix { inherit pkgs; };
    };
  };
}
