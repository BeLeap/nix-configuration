{ metadata, ... }:
{
  imports = [
    ./common.nix
  ];

  home.homeDirectory = "/home/${metadata.usernameLower}";
}
