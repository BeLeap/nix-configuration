{try}: {
  homeModules = [
    try.homeModules.default
    ({pkgs, ...}: let
      tryPackage = try.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
        ruby = pkgs.ruby_3_3;
      };
    in {
      home.packages = [
        pkgs.ruby_3_3
        tryPackage
      ];
      programs.try = {
        enable = true;
        package = tryPackage;
        path = "~/ws";
      };
    })
  ];
}
