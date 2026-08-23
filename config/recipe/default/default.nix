_: {
  includes = [
    # base setup
    "overlay"
    "hm"

    # good to share among all hosts
    "base"
    "nix"
    "agenix"

    "development"
    "firefox"

    # others
    "kubernetes"
  ];
  home = [
    ({config, ...}: {
      home.sessionPath = [
        "${config.home.homeDirectory}/.local/bin"
      ];
    })
  ];
}
