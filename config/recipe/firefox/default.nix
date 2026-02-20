_: {
  hm = [
    (
      { pkgs, ... }:
      {
  programs.firefox = {
    enable = true;

    package = pkgs.firefox-devedition;
  };
}
    )
  ];
}
