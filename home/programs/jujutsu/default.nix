{ metadata, pkgs, ... }:
{
  programs.jujutsu = {
    enable = true;
    package = pkgs.unstable.jujutsu;

    settings = {
      user = {
        email = metadata.email;
        name = metadata.username;
      };
      ui = {
        default-command = [
          "log"
          "--limit=10"
          "--no-pager"
        ];
      };
      aliases = {
        tug = [
          "bookmark"
          "move"
          "--from"
          "heads(::@- & bookmarks())"
          "--to"
          "@-"
        ];
      };
    };
  };
}
