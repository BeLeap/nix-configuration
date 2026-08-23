{
  inputs,
  host,
  ...
}: {config, ...}: {
  imports = [inputs.agenix.homeManagerModules.default];
  age.identityPaths = let
    common = import ./common.nix {homeDirectory = config.home.homeDirectory;};
  in
    common.ageIdentityPaths;
  home.packages = [inputs.agenix.packages.${host.platform}.default];
}
