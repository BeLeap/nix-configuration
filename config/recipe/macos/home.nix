{
  pkgs,
  metadata,
  lib,
  ...
}:
{
  imports = map (p: (./. + "/programs/${p}")) [
    "aerospace"
    "kdeconnect-mac"
  ];

  home.packages =
    with pkgs;
    [
      mas
    ]
    ++ (lib.optionals (metadata.kind == "personal") [ ])
    ++ (lib.optionals (metadata.kind == "work") [ ]);

  home.homeDirectory = "/Users/${metadata.usernameLower}";
}
