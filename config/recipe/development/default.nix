_: {
  recipes = [
    "wezterm"
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
    "podman"
    "nodejs"
    "pi"
    "try"
  ];
  hm = [
    (
      {pkgs, ...}: {
        home = {
          packages = with pkgs; [
            htop
            wireshark
            nerd-fonts.caskaydia-cove
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
            gettext
            minio-client
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
            MAKEFLAGS = "-j$(${pkgs.coreutils-full}/bin/nproc)";
            LC_ALL = "en_US.UTF-8";
          };
        };
      }
    )
  ];
}
