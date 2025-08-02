_: {
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
