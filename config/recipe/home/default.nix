{ lib, metadata, pkgs, config, ... }:
let
  basePrograms = [
    "zsh"
    "lsd"
    "starship"
    "carapace"
    "helix"
    "zoxide"
    "direnv"
    "git"
    "fzf"
    "gh"
    "bash"
    "jujutsu"
    "ssh"
    "nh"
    "podman"
    "codex"
    "claude-code"
  ];
  guiPrograms = [
    "firefox"
    "wezterm"
  ];
  macosPrograms = [
    "aerospace"
    "kdeconnect-mac"
  ];
  nixosGuiPrograms = [
    "hyprland"
    "rofi"
    "waybar"
  ];
in
{
  hm =
    { ... }:
    {
      programs.home-manager.enable = true;
      home =
        {
          stateVersion = "25.05";
          username = metadata.usernameLower;
        }
        // lib.optionalAttrs (metadata.distribution == "macos") {
          homeDirectory = "/Users/${metadata.usernameLower}";
        };

      home.packages =
        with pkgs;
        [
          htop
          wireshark
          cascadia-code
          nanum-gothic-coding
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
          fzf-make
          boda
          ghc
          yaml-language-server
          empiriqa
          gnumake
          croc
          dnsi
          crane
          coreutils-full
          gtrash
          dive
          pgcli
          mycli
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
            unstable.jira-cli-go
          ]
        ))
        ++ (lib.optionals (metadata.distribution == "macos") [
          pkgs.mas
        ]);

      imports =
        map (p: (./. + "/programs/${p}")) (
          basePrograms
          ++ (lib.optionals metadata.gui guiPrograms)
          ++ (lib.optionals (metadata.distribution == "macos") macosPrograms)
          ++ (lib.optionals (metadata.distribution == "nixos" && metadata.gui) nixosGuiPrograms)
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
        jgp = "jj git push";

        e = "$EDITOR";

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

      home.file =
        {
          "dl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Downloads";
        }
        // lib.genAttrs [ ".claude/CLAUDE.md" ".codex/AGENTS.md" ] (_: {
          source = ../../../files/AGENTS.md;
        })
        // lib.optionalAttrs (metadata.distribution == "macos") {
          ".config/nixpkgs/config.nix".text = ''
            {
              allowUnfree = true;
              android_sdk.accept_license = true;
            }
          '';
        };

    }
    // lib.optionalAttrs (metadata.distribution == "nixos") {
      xdg = {
        enable = true;
        userDirs.enable = true;
      };
    };
}
