_: {
  hm = [
    (
      {
        metadata,
        pkgs,
        lib,
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

              diff-formatter = "delta";
              conflict-marker-style = "git";
            };
            merge-tools.delta = {
              program = "${lib.getExe pkgs.delta}";
              merge-args = ["-s" "$left" "$output" "--width=$width"];
              diff-expected-exit-codes = [0 1];
            };
            aliases = {
              d = ["describe"];
              n = ["new"];
              p = ["git" "push"];
              f = ["git" "fetch" "--all-remotes"];
              st = ["status"];
              l = ["log" "--limit=20"];
              df = ["diff"];
              e = ["edit"];
              wl = ["workspace" "list"];
              wa = ["workspace" "add"];
              wf = ["workspace" "forget"];
              wr = ["workspace" "root"];
              wus = ["workspace" "update-stale"];
              b = ["bookmark"];
              ba = ["bookmark" "advance"];
              sq = ["squash"];
            };
            templates = {
              draft_commit_description = ''
                concat(
                  description,
                  "\n\n",
                  "JJ: ignore-rest\n",
                  "JJ: ------------------------ >8 ------------------------\n",
                  diff.git(),
                )
              '';
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
