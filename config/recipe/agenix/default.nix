{ agenix }:
{
  base = [
    agenix.nixosModules.default
    (
      { system }:
      {
        environment.systemPackages = [ agenix.packages.${system}.default ];
      }
    )
  ];
}
