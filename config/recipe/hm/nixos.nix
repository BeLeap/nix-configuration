{
  ...
}: {
  imports = [
    ./common.nix
  ];

  home.packages = [];

  xdg.enable = true;
  xdg.userDirs.enable = true;
}
