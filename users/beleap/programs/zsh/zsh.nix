_: {
  programs.zsh = {
    enable = true;

    autocd = true;

    autosuggestion = {
      enable = true;
    };

    shellAliases = {
      ga = "git add";
      gc = "git commit -v";
      gst = "git status";
      gp = "git push";
      gf = "git fetch --all --prue";

      sozsh = "source ~/.zshrc";
    };
  };
}
