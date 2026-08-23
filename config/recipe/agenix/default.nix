{
  inputs,
  host,
  ...
}: {
  system = [
    (_: {
      imports = [inputs.agenix.nixosModules.default];
    })
    (_: {
      environment.systemPackages = [inputs.agenix.packages.${host.platform}.default];
    })
  ];
  home = [
    (import ../../../lib/agenix/hm.nix {inherit inputs host;})
  ];
}
