{
  metadata,
  pkgs,
  lib,
  ...
}:
{
  programs.home-manager.enable = true;
  home.stateVersion = "25.05";

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
      yq-go
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
      croc
      dnsi
      crane
      coreutils-full
      gtrash
    ]
    ++ (lib.optionals (metadata.kind == "personal") [
      pkgs._1password-cli
    ])
    # Discord packages is not supported on aarch64-linux
    ++ (lib.optionals (metadata.kind == "personal" && (metadata.platform == "x86_64-linux")) [
      pkgs.discord
    ])
    ++ (lib.optionals (metadata.kind == "work") (
      with pkgs;
      [
        claude-code
        unstable.jira-cli-go
        jetbrains.idea-ultimate
        jetbrains.datagrip
      ]
    ));

  imports =
    [ ]
    ++ map (p: (./. + "/programs/${p}")) (
      [
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
        "jujutsu"
        "ssh"
        "nh"
        "podman"
        "codex"
      ]
      ++ (lib.optionals (metadata.gui) [
        "firefox"
        "wezterm"
      ])
    );

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

    rm = "echo Use the full path i.e. '/bin/rm', consider using trash";
    tp = "gtrash p";
  };
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "hx";

    MAKEFLAGS = "-j$(nproc)";
  };

  home.username = metadata.usernameLower;

  home.file =
    { }
    // lib.genAttrs [ ".claude/CLAUDE.md" ".codex/AGENTS.md" ] (_: {
      source = ../files/AGENTS.md;
    });
}
