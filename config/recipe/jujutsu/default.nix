_: {
  home = [
    (
      {
        host,
        pkgs,
        lib,
        config,
        ...
      }: {
        home.file.".agents/skills/jj-vcs".source = ./skills/jj-vcs;
        home.file.".config/jj/pre-commit-config.yaml".source = ./pre-commit-config.yaml;

        home.packages = [
          (pkgs.writeShellApplication {
            name = "jj-gitleaks-files";
            runtimeInputs = [pkgs.gitleaks];
            text = builtins.readFile ./gitleaks-files.sh;
          })
        ];

        programs.jujutsu = {
          enable = true;
          package = pkgs.unstable.jujutsu;

          settings = {
            user = {
              inherit (host) email;
              name = host.username;
            };
            ui = {
              default-command = [
                "log"
                "--limit=10"
                "--no-pager"
              ];

              diff-formatter = "delta";
              conflict-marker-style = "git";
              diff-editor = ["nvim" "-c" "DiffEditor $left $right $output"];
            };
            merge-tools.delta = {
              program = "${lib.getExe pkgs.delta}";
              diff-args = ["-s" "$left" "$right" "--width=$width"];
              diff-expected-exit-codes = [0 1];
            };
            merge-tools.hunk = {
              program = "sh";
              diff-invocation-mode = "dir";
              diff-do-chdir = false;
              conflict-marker-style = "snapshot";
              diff-args = [
                "-c"
                "exec nvim -c \"HunkDiffView $1 $2\" </dev/tty >/dev/tty"
                "hunk-difftool"
                "$left"
                "$right"
              ];
            };
            aliases = {
              c = ["commit"];
              d = ["describe"];
              n = ["new"];
              p = ["push"];
              push = [
                "util"
                "exec"
                "--"
                "${lib.getExe pkgs.unstable.jj-pre-push}"
                "--config"
                "${config.xdg.configHome}/jj/pre-commit-config.yaml"
                "push"
              ];
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
              sq = ["squash" "-i"];
              dfui = ["diff" "--tool" "hunk" "--no-pager"];
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
