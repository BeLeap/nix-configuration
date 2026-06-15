{
  pkgs,
  metadata,
  ...
}: {
  imports = [
    ../common.nix
  ];

  home = {
    packages = with pkgs; [
      mas
    ];

    homeDirectory = "/Users/${metadata.usernameLower}";

    file.".config/nixpkgs/config.nix".text = ''
      {
        allowUnfree = true;
        android_sdk.accept_license = true;
      }
    '';
  };
}
