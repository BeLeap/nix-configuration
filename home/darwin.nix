{
  pkgs,
  kind,
  username,
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

  home.username = username;
  home.homeDirectory = "/Users/${username}";

  home.packages = [
    pkgs.htop
    pkgs.utm
    pkgs.wireshark
    pkgs.cascadia-code
  ]
  ++ (if (kind == "personal") then [ pkgs.discord ] else [ ]);

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
    ];
}
