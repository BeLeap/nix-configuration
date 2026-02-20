{
  nixpkgs,
  metadata,
  lib,
}: {
  base = {pkgs, ...}: {
    virtualisation.host.pkgs = import nixpkgs {system = "aarch64-darwin";};
    boot.binfmt.emulatedSystems = [
      "x86_64-linux"
    ];
    virtualisation.sharedDirectories = {
      defaultShared = {
        source = "/Users/${metadata.usernameLower}/shared";
        target = "/home/${metadata.usernameLower}/shared";
      };
    };
  };
}
