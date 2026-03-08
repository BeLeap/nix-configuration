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
            };
            templates = {
              draft_commit_description = ''
                concat(
                  description,
                  "\n\n",
                  "JJ: ignore-rest\n",
                  "\nChanges in this commit:\n",
                  "```diff\n",
                  diff.git(),
                  "\n```\n",
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
