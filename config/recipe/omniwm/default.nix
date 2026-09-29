_: {
  home = [
    ({pkgs, ...}: {
      home.packages = [pkgs.unstable.omniwm];
      home.file.".config/omniwm/settings.toml".source = ./settings.toml;
    })
  ];
}
