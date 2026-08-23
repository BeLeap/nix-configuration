{
  metadata,
  agenix,
}: {
  systemModules = [
    (_: {
      imports = [agenix.nixosModules.default];
    })
    (_: {
      environment.systemPackages = [agenix.packages.${metadata.platform}.default];
    })
  ];
  homeModules = [
    (import ../../../lib/agenix/hm.nix {inherit agenix metadata;})
  ];
}
