{try}: {
  hm = [
    try.homeModules.default
    ({pkgs, ...}: {
      home.packages = [pkgs.ruby_3_3];
      programs.try = {
        enable = true;
        package = try.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
          ruby = pkgs.ruby_3_3;
        };
      };
    })
  ];
}
