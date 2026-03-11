{
  metadata,
  agenix,
}: {
  base = [
    agenix.nixosModules.default
    {
      environment.systemPackages = [agenix.packages.${metadata.platform}.default];
    }
  ];
  hm = [
    (import ../../../lib/agenix/hm.nix {inherit agenix metadata;})
  ];
}
