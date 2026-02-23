{
  metadata,
  agenix,
}: let
  common = import ../../lib/agenix/common.nix {inherit metadata;};
  age = {
    identityPaths = common.ageIdentityPaths;
    secrets = {
      some-secret.file = ./secrets/some-secret.age;
    };
  };
in {
  base = [
    agenix.nixosModules.default
    {
      environment.systemPackages = [agenix.packages.${metadata.platform}.default];

      inherit age;
    }
  ];
  hm = [
    (import ../../lib/agenix/hm.nix {inherit agenix metadata;})
  ];
}
