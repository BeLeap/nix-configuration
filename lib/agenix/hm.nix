{
  agenix,
  metadata,
  ...
}: let
  common = import ./common.nix {inherit metadata;};
in {
  imports = [agenix.homeManagerModules.default];
  age.identityPaths = common.ageIdentityPaths;
  home.packages = [agenix.packages.${metadata.platform}.default];
}
