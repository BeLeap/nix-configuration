{ nixpkgs, metadata }:
{
  base = {
    virtualisation.host.pkgs = nixpkgs.legacyPackages.aarch64-darwin;
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
