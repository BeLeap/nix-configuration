_: {
  programs.zsh = {
    enable = true;

    autocd = true;

    shellAliases = {
      ga = "git add";
      gc = "git commit -v";
      gst = "git status";

      sozsh = "source ~/.zshrc";
    };
  };
}
