{
  lib,
  metadata,
}: {
  recipes = [
    "ghostty"
    "tmux"
    "fish"
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
    "nodejs"
  ];
  hm = [
    (
      {pkgs, ...}: {
        home = {
          packages = with pkgs; [
            htop
            wireshark
            nerd-fonts.hack
            nanum-gothic-coding
            ipcalc
            mtr
            arping
            mitmproxy
            pchar
            ncdu
            yq-go
            watchexec
            beleap-utils
            gnupg
            oauth2c
            curl
            openssl
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
            # pgcli
            # mycli
            ssm-session-manager-plugin
            awscli2
            just
            vault-bin
            ts
          ];

          shellAliases = {
            e = "$EDITOR";

            rm = "echo Use the full path i.e. '/bin/rm', consider using trash";
            tp = "gtrash p";
            fm = "fzf-make";
            lT = "ls -t";
            llT = "ls -lt";
          };

          sessionVariables = {
            EDITOR = "hx";
            MAKEFLAGS = "-j$(nproc)";
            LC_ALL = "en_US.UTF-8";
          };
        };
      }
    )
    (
      {pkgs, ...}: let
        wsCleanupDays = 30;
        wsPath = "$HOME/ws";
        wsCleanupScript = pkgs.writeShellScript "ws-cleanup" ''
          set -euo pipefail

          if [ ! -d "${wsPath}" ]; then
            echo "[ws-cleanup] Skip: ${wsPath} does not exist."
            exit 0
          fi

          echo "[ws-cleanup] Removing first-level directories in ${wsPath} not accessed in the last ${toString wsCleanupDays} days."
          find "${wsPath}" \
            -mindepth 1 \
            -maxdepth 1 \
            -type d \
            -atime +${toString wsCleanupDays} \
            -print \
            -exec rm -rf -- {} +
        '';
      in {
        systemd.user = lib.mkIf (metadata.os == "linux") {
          services.ws-cleanup = {
            Unit = {
              Description = "Clean up stale first-level workspace directories";
            };
            Service = {
              Type = "oneshot";
              ExecStart = "${wsCleanupScript}";
            };
          };
          timers.ws-cleanup = {
            Unit = {
              Description = "Run workspace cleanup regularly";
            };
            Timer = {
              OnBootSec = "10m";
              OnUnitActiveSec = "1d";
              Persistent = true;
            };
            Install = {
              WantedBy = ["timers.target"];
            };
          };
        };

        launchd.agents.ws-cleanup = lib.mkIf (metadata.os == "darwin") {
          enable = true;
          config = {
            ProgramArguments = [
              "${pkgs.bash}/bin/bash"
              "${wsCleanupScript}"
            ];
            StartCalendarInterval = [
              {
                Hour = 4;
                Minute = 0;
              }
            ];
            StandardOutPath = "/tmp/ws-cleanup.out.log";
            StandardErrorPath = "/tmp/ws-cleanup.err.log";
          };
        };
      }
    )
  ];
}
