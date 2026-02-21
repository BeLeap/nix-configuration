{
  metadata,
  agenix,
}: let
  age = {
    identityPaths = [
      (
        if metadata.os == "darwin"
        then "/Users/${metadata.usernameLower}/.ssh/id_ed25519"
        else "/home/${metadata.usernameLower}/.ssh/id_ed25519"
      )
    ];
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
    {
      imports = [agenix.homeManagerModules.default];
      inherit age;
    }
  ];
}
