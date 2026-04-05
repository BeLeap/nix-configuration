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

    "nixos"

    "development"

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
