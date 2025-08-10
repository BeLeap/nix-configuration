{
  metadata,
  pkgs,
  ...
}:
{
  imports = [
    ./common.nix
  ];

  home.packages = with pkgs; [
    utm
  ];

  home.homeDirectory = "/Users/${metadata.usernameLower}";
}
