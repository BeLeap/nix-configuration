{
  inputs,
  host,
  ...
}: {
  systemModules = [
    (_: {
      imports = [inputs.agenix.nixosModules.default];
    })
    (_: {
      environment.systemPackages = [inputs.agenix.packages.${host.platform}.default];
    })
  ];
  homeModules = [
    (import ../../../lib/agenix/hm.nix {inherit inputs host;})
  ];
}
