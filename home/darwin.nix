{
  pkgs,
  metadata,
  ...
}:
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.11";

  home.username = metadata.usernameLower;
  home.homeDirectory = "/Users/${metadata.usernameLower}";

  home.packages = [
    pkgs.htop
    pkgs.utm
    pkgs.wireshark
    pkgs.cascadia-code
    pkgs.kubectl
    pkgs.kubectl-node-shell
    pkgs.kubectl-view-secret
    pkgs.kubectx
    pkgs.ipcalc
    pkgs.mtr
    pkgs.arping
    pkgs.mitmproxy
    pkgs.ncdu
    pkgs.yq
    pkgs.watchexec
    pkgs.beleap-utils
    pkgs.gnupg
    pkgs.oauth2c
    pkgs.curl
    pkgs.kubectl-check
    pkgs.boda
  ]
  ++ (if (metadata.kind == "personal") then [ pkgs.discord ] else [ ]);

  imports =
    [ ]
    ++ map (p: (./. + "/programs/${p}")) [
      "zsh"
      "lsd"
      "starship"
      "carapace"
      "helix"
      "ghostty"
      "zoxide"
      "direnv"
      "git"
      "fzf"
      "k9s"
      "gh"
    ];
}
