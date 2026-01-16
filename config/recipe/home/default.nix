{ lib, metadata, pkgs, config, ... }:
let
  isMacos = metadata.distribution == "macos";
  isNixos = metadata.distribution == "nixos";
  isPersonal = metadata.kind == "personal";
  isWork = metadata.kind == "work";
  isGui = metadata.gui;
  isX86Linux = metadata.platform == "x86_64-linux";

  basePrograms = [
    "shell/zsh"
    "shell/bash"
    "shell/starship"
    "shell/carapace"
    "shell/zoxide"
    "editor/helix"
    "vcs/git"
    "vcs/jujutsu"
    "vcs/gh"
    "tools/direnv"
    "tools/fzf"
    "tools/lsd"
    "tools/nh"
    "tools/ssh"
    "tools/podman"
    "ai/codex"
    "ai/claude-code"
  ];
  guiPrograms = [
    "gui/firefox"
    "gui/wezterm"
  ];
  macosPrograms = [
    "macos/aerospace"
    "macos/kdeconnect-mac"
  ];
  nixosGuiPrograms = [
    "wm/hyprland"
    "wm/rofi"
    "wm/waybar"
  ];

  baseImports = map (p: (./. + "/programs/${p}")) basePrograms;
  guiImports = map (p: (./. + "/programs/${p}")) guiPrograms;
  macosImports = map (p: (./. + "/programs/${p}")) macosPrograms;
  nixosGuiImports = map (p: (./. + "/programs/${p}")) nixosGuiPrograms;

  basePackages = with pkgs; [
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
  ];
in
{
  hm =
    { ... }:
    lib.mkMerge [
      {
        programs.home-manager.enable = true;
        home =
          {
            stateVersion = "25.05";
            username = metadata.usernameLower;
          }
          // lib.optionalAttrs isMacos {
            homeDirectory = "/Users/${metadata.usernameLower}";
          };

        home.packages = basePackages;
        imports = baseImports;

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
          });
      }

      (lib.mkIf isPersonal {
        home.packages =
          with pkgs;
          [
            _1password-cli
          ]
          # Discord packages is not supported on aarch64-linux
          ++ lib.optional isX86Linux discord;
      })

      (lib.mkIf isWork {
        home.packages = with pkgs; [
          unstable.jira-cli-go
        ];
      })

      (lib.mkIf isGui {
        imports = guiImports;
      })

      (lib.mkIf isMacos {
        home.packages = [ pkgs.mas ];
        imports = macosImports;
        home.file.".config/nixpkgs/config.nix".text = ''
          {
            allowUnfree = true;
            android_sdk.accept_license = true;
          }
        '';
      })

      (lib.mkIf (isNixos && isGui) {
        imports = nixosGuiImports;
      })

      (lib.mkIf isNixos {
        xdg = {
          enable = true;
          userDirs.enable = true;
        };
      })
    ];
}
