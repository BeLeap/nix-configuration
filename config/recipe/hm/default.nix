{
  metadata,
  home-manager,
}: {
  systemModules = [
    (_: {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bak";
        extraSpecialArgs = {inherit metadata;};
      };
    })
  ];
}
