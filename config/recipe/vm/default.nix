{
  inputs,
  host,
  ...
}: {
  systemModules = [
    (_: {
      virtualisation.host.pkgs = import inputs.nixpkgs {system = "aarch64-darwin";};
      boot.binfmt.emulatedSystems = [
        "x86_64-linux"
      ];
      virtualisation.sharedDirectories = {
        defaultShared = {
          source = "/Users/${host.usernameLower}/shared";
          target = "/home/${host.usernameLower}/shared";
        };
      };
    })
  ];
}
