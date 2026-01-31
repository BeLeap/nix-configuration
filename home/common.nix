{
  metadata,
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.home-manager.enable = true;
  home.stateVersion = "25.05";

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  home.username = metadata.usernameLower;

  home.file = {
    "dl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Downloads";
  }
  // lib.genAttrs [ ".claude/CLAUDE.md" ".codex/AGENTS.md" ] (_: {
    source = ../files/AGENTS.md;
  });
}
