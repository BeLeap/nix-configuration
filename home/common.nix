{
  metadata,
  pkgs,
  lib,
  ...
}:
{
  programs.home-manager.enable = true;
  home.stateVersion = "25.11";

  home.packages =
    with pkgs;
    [
      htop
      wireshark
      cascadia-code
      nanum-gothic-coding
      kubectl
      kubectl-node-shell
      kubectl-view-secret
      kubectx
      ipcalc
      mtr
      arping
      mitmproxy
      ncdu
      yq
      watchexec
      beleap-utils
      gnupg
      oauth2c
      curl
      kubectl-check
      boda
      kotlin-ls
      kubernetes-helm
      ghc
      yaml-language-server
      empiriqa
      gnumake
      kind
      podman
      podman-compose
      croc
    ]
    ++ (lib.optionals (metadata.kind == "personal") [
      pkgs.codex
      pkgs._1password-cli
    ])
    # Discord packages is not supported on aarch64-linux
    ++ (lib.optionals (metadata.kind == "personal" && (metadata.platform == "x86_64-linux")) [
      pkgs.discord
    ])
    ++ (lib.optionals (metadata.kind == "work") [ pkgs.claude-code ]);

  imports =
    [ ]
    ++ map (p: (./. + "/programs/${p}")) [
      "zsh"
      "lsd"
      "starship"
      "carapace"
      "helix"
      "zoxide"
      "direnv"
      "git"
      "fzf"
      "k9s"
      "gh"
      "bash"
      "firefox"
      "wezterm"
      "jujutsu"
      "ssh"
    ];

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
    jgp = "jj git push --allow-new";

    e = "$EDITOR";

    k = "kubectl-check";
    ku = "k9s";

    docker = "podman";

    sozsh = "source ~/.zshrc";
  };
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "hx";
  };

  home.username = metadata.usernameLower;

  home.file =
    { }
    // lib.genAttrs [ ".claude/CLAUDE.md" ".codex/AGENTS.md" ] (_: {
      text = builtins.readFile ../files/AGENTS.md;
    });
}
