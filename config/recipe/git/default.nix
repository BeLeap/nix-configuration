_: {
  hm = [
    (
      { metadata, ... }:
      {
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = metadata.username;
        email = metadata.email;
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
      help.autocorret = "prompt";
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
