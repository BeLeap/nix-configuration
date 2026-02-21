{
  pkgs,
  metadata,
  lib,
  ...
}: {
  imports = [
    ./common.nix
  ];

  home = {
    packages = with pkgs;
      [
        mas
      ]
      ++ (lib.optionals (metadata.kind == "personal") [])
      ++ (lib.optionals (metadata.kind == "work") []);

    homeDirectory = "/Users/${metadata.usernameLower}";

    file.".config/nixpkgs/config.nix".text = ''
      {
        allowUnfree = true;
        android_sdk.accept_license = true;
      }
    '';
  };
}
