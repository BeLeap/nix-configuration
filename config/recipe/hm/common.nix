{
  metadata,
  pkgs,
  lib,
  config,
  ...
}: {
  programs.home-manager.enable = true;
  home = {
    stateVersion = "25.05";

    sessionVariables = {
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
    };

    # Discord packages is not supported on aarch64-linux
    packages = lib.optionals (metadata.kind == "personal" && metadata.platform == "x86_64-linux") [
      pkgs.discord
    ];

    username = metadata.usernameLower;

    file =
      {
        "dl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Downloads";
      }
      // lib.genAttrs [".claude/CLAUDE.md" ".codex/AGENTS.md"] (_: {
        source = ../../../files/AGENTS.md;
      });
  };
}
