{
  metadata,
  pkgs,
  lib,
  ...
}:
{
  home.packages = [
    pkgs.htop
    pkgs.wireshark
    pkgs.cascadia-code
    pkgs.nanum-gothic-coding
    pkgs.kubectl
    pkgs.kubectl-node-shell
    pkgs.kubectl-view-secret
    pkgs.kubectx
    pkgs.ipcalc
    pkgs.mtr
    pkgs.arping
    pkgs.mitmproxy
    pkgs.ncdu
    pkgs.yq
    pkgs.watchexec
    pkgs.beleap-utils
    pkgs.gnupg
    pkgs.oauth2c
    pkgs.curl
    pkgs.kubectl-check
    pkgs.boda
    pkgs.kotlin-ls
    pkgs.kubernetes-helm
  ]
  ++ (lib.optionals (metadata.os == "macos") [ pkgs.utm ])
  ++ (lib.optionals (metadata.kind == "personal") [
    pkgs.discord
    pkgs.gemini-cli
  ])
  ++ (lib.optionals (metadata.kind == "work") [ pkgs.claude-code ]);

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

    e = "$EDITOR";

    k = "kubectl-check";
    ku = "k9s";

    sozsh = "source ~/.zshrc";
  };
}
