{
  metadata,
  pkgs,
  ...
}:
{
  imports = [
    ./common.nix
  ]
  ++ map (p: (./. + "/programs/${p}")) [
    "aerospace"
  ];

  home.packages = with pkgs; [
    utm
  ];

  home.homeDirectory = "/Users/${metadata.usernameLower}";
}
