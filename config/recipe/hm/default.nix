{
  metadata,
  home-manager,
}: {
  base = [
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bak";
        extraSpecialArgs = {inherit metadata;};
      };
    }
  ];
}
