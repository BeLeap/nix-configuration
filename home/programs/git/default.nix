{ metadata, ... }:
{
  programs.git = {
    enable = true;

    userName = metadata.username;
    userEmail = metadata.email;

    aliases = {
      adog = "log --all --decorate --oneline --graph";
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

    extraConfig = {
      push = {
        autoSetupRemote = true;
      };
      pull = {
        rebase = true;
      };
      rerere = {
        enable = true;
      };
      column = {
        ui = "auto";
      };
      branch = {
        sort = "-committerdate";
      };
      fetch = {
        writeCommitGraph = true;
      };
      help = {
        autocorret = "prompt";
      };
      pack = {
        usePathWalk = true;
      };
      init = {
        defaultBranch = "master";
      };
    };
  };
}
