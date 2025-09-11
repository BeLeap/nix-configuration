{
  metadata,
  ...
}:
{
  imports = [
    ./common.nix
  ]
  ++ map (p: (./. + "/programs/${p}")) [
    "aerospace"
  ];

  home.packages = [ ];

  home.homeDirectory = "/Users/${metadata.usernameLower}";
}
