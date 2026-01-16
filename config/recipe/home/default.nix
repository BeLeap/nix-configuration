{ lib, metadata, pkgs, config, ... }:
let
  isMacos = metadata.distribution == "macos";
  isNixos = metadata.distribution == "nixos";
  isPersonal = metadata.kind == "personal";
  isWork = metadata.kind == "work";
  isGui = metadata.gui;
  isX86Linux = metadata.platform == "x86_64-linux";

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

  baseImports = map (p: (../home-shell + "/${p}")) [
    "zsh"
    "bash"
    "starship"
    "carapace"
    "zoxide"
  ]
  ++ map (p: (../home-editor + "/${p}")) [
    "helix"
  ]
  ++ map (p: (../home-vcs + "/${p}")) [
    "git"
    "jujutsu"
    "gh"
  ]
  ++ map (p: (../home-tools + "/${p}")) [
    "direnv"
    "fzf"
    "lsd"
    "nh"
    "ssh"
    "podman"
  ]
  ++ map (p: (../home-ai + "/${p}")) [
    "codex"
    "claude-code"
  ];
  guiImports = map (p: (../home-gui + "/${p}")) guiPrograms;
  macosImports = map (p: (../home-macos + "/${p}")) macosPrograms;
  nixosGuiImports = map (p: (../home-wm + "/${p}")) nixosGuiPrograms;

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
        imports = baseImports;
        home = {
          stateVersion = "25.05";
          username = metadata.usernameLower;
          packages = basePackages;
          shellAliases = {
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
          sessionVariables = {
            LANG = "en_US.UTF-8";
            LC_CTYPE = "en_US.UTF-8";
            LC_ALL = "en_US.UTF-8";
            EDITOR = "hx";

            MAKEFLAGS = "-j$(nproc)";
          };
          file =
            {
              "dl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Downloads";
            }
            // lib.genAttrs [ ".claude/CLAUDE.md" ".codex/AGENTS.md" ] (_: {
              source = ../../../files/AGENTS.md;
            });
        };
      }

      (lib.mkIf isPersonal {
        home.packages = with pkgs; [
          _1password-cli
        ];
      })

      (lib.mkIf (isPersonal && isX86Linux) {
        home.packages = [ pkgs.discord ];
      })

      (lib.mkIf isWork {
        home.packages = [ pkgs.unstable.jira-cli-go ];
      })

      (lib.mkIf isGui {
        imports = guiImports;
      })

      (lib.mkIf isMacos {
        home = {
          homeDirectory = "/Users/${metadata.usernameLower}";
          packages = [ pkgs.mas ];
          file.".config/nixpkgs/config.nix".text = ''
            {
              allowUnfree = true;
              android_sdk.accept_license = true;
            }
          '';
        };
        imports = macosImports;
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
