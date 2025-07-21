_: {
  programs.zsh = {
    enable = true;

    autocd = true;

    autosuggestion = {
      enable = true;
    };
    syntaxHighlighting = {
      enable = true;
    };

    initContent = ''
      # Safety
      setopt noclobber nomatch

      # Directory convenience
      setopt autocd chase_links
      setopt pushd_ignore_dups pushd_silent pushd_to_home

      # History behavior
      setopt share_history inc_append_history
      setopt hist_ignore_dups hist_ignore_space

      # Globbing
      setopt extended_glob

      # Spell-check
      setopt correct_all

      bindkey -v

      export PATH=/run/current-system/sw/bin:$PATH
    '';

    shellAliases = {
      ga = "git add";
      gc = "git commit -v";
      gst = "git status";
      gp = "git push";
      gf = "git fetch --all --prune";
      gd = "git diff";
      ggr = "cd $(git rev-parse --show-toplevel 2>/dev/null)";
      gl = "git pull --rebase";
      gr = "git rebase --autostash --autosquash";

      prcm = "gh pr create --assignee @me";
      prv = "gh pr view";
      prvw = "gh pr view -w";
      prm = "gh pr merge";
      prmd = "gh pr merge -d";

      e = "$EDITOR";

      sozsh = "source ~/.zshrc";
    };
  };
}
