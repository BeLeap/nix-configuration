{
  lib,
  metadata,
  ...
}: {
  recipes =
    [
      "wezterm"
      "zsh"
      "lsd"
      "starship"
      "carapace"
      "helix"
      "zoxide"
      "direnv"
      "git"
      "fzf"
      "gh"
      "bash"
      "nushell"
      "jujutsu"
      "ssh"
      "nh"
      "podman"
      "codex"
    ]
    ++ (lib.optionals (metadata.gui) [
      "firefox"
    ]);
  hm = [
    (
      {
        pkgs,
        metadata,
        ...
      }: {
        home.packages = with pkgs;
          [
            htop
            wireshark
            cascadia-code
            nanum-gothic-coding
            ipcalc
            mtr
            arping
            mitmproxy
            pchar
            ncdu
            yq-go
            watchexec
            beleap-utils
            gnupg
            oauth2c
            curl
            fzf-make
            boda
            ghc
            yaml-language-server
            empiriqa
            gnumake
            croc
            dnsi
            crane
            coreutils-full
            gtrash
            dive
            # pgcli
            # mycli
            ssm-session-manager-plugin
            awscli2
            just
          ]
          ++ (lib.optionals (metadata.kind == "personal") [
            pkgs._1password-cli
          ])
          ++ (lib.optionals (metadata.kind == "work") (
            with pkgs; [
              unstable.jira-cli-go
            ]
          ));

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

          prcm = "gh pr create --assignee @me";
          prv = "gh pr view";
          prvw = "gh pr view -w";
          prm = "gh pr merge";
          prmd = "gh pr merge -d";

          jgf = "jj git fetch --all-remotes";
          jgp = "jj git push";

          e = "$EDITOR";

          docker = "podman";

          rm = "echo Use the full path i.e. '/bin/rm', consider using trash";
          tp = "gtrash p";
          fm = "fzf-make";
        };

        home.sessionVariables = {
          EDITOR = "hx";
          MAKEFLAGS = "-j$(nproc)";
        };
      }
    )
  ];
}
