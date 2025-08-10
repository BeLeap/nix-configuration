{
  metadata,
  ...
}:
{
  imports = [
    ./common.nix
  ];

  home.homeDirectory = "/Users/${metadata.usernameLower}";
}
