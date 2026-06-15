{
  agenix,
  metadata,
  ...
}: {config, ...}: {
  imports = [agenix.homeManagerModules.default];
  age.identityPaths = let
    common = import ./common.nix {homeDirectory = config.home.homeDirectory;};
  in
    common.ageIdentityPaths;
  home.packages = [agenix.packages.${metadata.platform}.default];
}
