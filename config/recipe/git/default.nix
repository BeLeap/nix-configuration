_: {
  home = [
    (
      {
        host,
        pkgs,
        ...
      }: {
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

          hooks.pre-commit = pkgs.writeShellScript "gitleaks-pre-commit" ''
            ${pkgs.gitleaks}/bin/gitleaks protect --staged --redact --exit-code 10
            status=$?

            case "$status" in
              0) exit 0 ;;
              10) ;;
              *)
                printf '%s\n' 'Gitleaks scan failed. Commit aborted.' >&2
                exit "$status"
                ;;
            esac

            # Git hooks may have redirected stdin; read from the terminal instead.
            if ! { exec 3<> /dev/tty; } 2>/dev/null; then
              printf '%s\n' 'Secrets detected, but no terminal is available for confirmation. Commit aborted.' >&2
              exit 1
            fi

            printf '%s' 'Secrets detected. Continue? [y/N] ' >&3
            answer=
            IFS= read -r answer <&3 || exit 1
            case "$answer" in
              y|Y) exit 0 ;;
              *)
                printf '%s\n' 'Commit aborted.' >&2
                exit 1
                ;;
            esac
          '';

          settings = {
            user = {
              name = host.username;
              inherit (host) email;
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
            ".envrc"
            ".DS_Store"
            "shell.nix"
            ".helix"
            "*.LOCAL.*"
            ".journal/"
          ];
        };
      }
    )
  ];
}
