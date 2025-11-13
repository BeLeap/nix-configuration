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
    "kdeconnect-mac"
  ];

  home.packages = [ ];

  home.homeDirectory = "/Users/${metadata.usernameLower}";
}
