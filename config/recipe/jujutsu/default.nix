_: {
  hm = [
    (
      {
        metadata,
        pkgs,
        ...
      }: {
        programs.jujutsu = {
          enable = true;
          package = pkgs.unstable.jujutsu;

          settings = {
            user = {
              inherit (metadata) email;
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
              c = ["commit"];
              p = ["git" "push"];
              f = ["git" "fetch" "--all-remotes"];
              st = ["status"];
              l = ["log" "--limit=20"];
              d = ["diff"];
              e = ["edit"];
              wl = ["workspace" "list"];
              wa = ["workspace" "add"];
              wf = ["workspace" "forget"];
              wr = ["workspace" "root"];
              wus = ["workspace" "update-stale"];
              tug = [
                "bookmark"
                "move"
                "--from"
                "heads(::@- & bookmarks())"
                "--to"
                "@-"
              ];
            };
            remotes = {
              origin = {
                auto-track-bookmarks = "glob:*";
              };
            };
          };
        };
      }
    )
  ];
}
