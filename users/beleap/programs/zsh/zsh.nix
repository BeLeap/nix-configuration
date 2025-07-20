_: {
  programs.zsh = {
    enable = true;

    shellAliases = {
      ga = "git add";
      gc = "git commit -v";
      gst = "git status";
    };
  };
}
