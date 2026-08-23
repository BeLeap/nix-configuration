_: {
  systemModules = [
    ({
      inputs,
      host,
      ...
    }: {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bak";
        extraSpecialArgs = {inherit inputs host;};
      };
    })
  ];
}
