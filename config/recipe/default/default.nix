_: {
  recipes = [
    # base setup
    "overlay"
    "hm"
    "macAppUtil"

    # good to share among all hosts
    "base"
    "nix"
    "agenix"

    "development"
    "firefox"

    # others
    "kubernetes"
  ];
  hm = [
    ({config, ...}: {
      home.sessionPath = [
        "${config.home.homeDirectory}/.local/bin"
      ];
    })
  ];
}
