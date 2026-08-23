{
  pkgs,
  host,
  ...
}: {
  imports = [
    ../common.nix
  ];

  home = {
    packages = with pkgs; [
      mas
    ];

    homeDirectory = "/Users/${host.usernameLower}";

    file.".config/nixpkgs/config.nix".text = ''
      {
        allowUnfree = true;
        android_sdk.accept_license = true;
      }
    '';
  };
}
