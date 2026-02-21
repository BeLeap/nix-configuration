_: {
  hm = [
    (
      {metadata, ...}: {
        home.shellAliases = {
          ga = "git add";
          gc = "git commit -v";
          gst = "git status";
          gp = "git push";
          gf = "git fetch --all --prune";
          gd = "git diff";
          ggr = "cd $(git rev-parse --show-toplevel 2>/dev/null)";
          gl = "git pull --rebase";
          gr = "git rebase --autostash --autosquash";
          gsw = "git switch";
          glp = "git pull --rebase && git push";
        };
        programs.git = {
          enable = true;

          settings = {
            user = {
              name = metadata.username;
              inherit (metadata) email;
            };

            alias = {
              adog = "log --all --decorate --oneline --graph";
            };
            push.autoSetupRemote = true;
            pull.rebase = true;
            rerere.enable = true;
            column.ui = "auto";
            branch.sort = "-committerdate";
            fetch.writeCommitGraph = true;
            help.autocorrect = "prompt";
            pack.usePathWalk = true;
            init.defaultBranch = "master";
          };

          ignores = [
            "root.mark"
            ".tool-versions"
            ".envrc"
            ".helix"
            "CLAUDE.md"
            "shell.nix"
            "*.TEMP.*"
            ".claude"
            ".profileconfig.json"
          ];
        };
      }
    )
  ];
}
