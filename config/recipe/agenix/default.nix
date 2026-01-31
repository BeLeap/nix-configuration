{ metadata, agenix }:
{
  base = [
    agenix.nixosModules.default
    {
      environment.systemPackages = [ agenix.packages.${metadata.platform}.default ];
    }
  ];
}
