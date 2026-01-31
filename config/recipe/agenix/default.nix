{ metadata, agenix }:
{
  base = [
    agenix.nixosModules.default
    {
      environment.systemPackages = [ agenix.packages.${metadata.platform}.default ];

      age.secrets = {
        some-secret.file = "./secrets/some-secret.age";
      };
    }
  ];
  hm = [
    {
      age = {
        identityPath = [ "~/.ssh/id_ed25519" ];
        secrets = {
          some-secret.file = "./secrets/some-secret.age";
        };
      };
    }
  ];
}
