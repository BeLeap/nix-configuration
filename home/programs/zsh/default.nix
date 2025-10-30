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
      # setopt correct_all

      bindkey -v
    '';

    shellAliases = {
      sozsh = "source ~/.zshrc";
    };
  };
}
