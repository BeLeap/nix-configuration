{home-manager, ...}: {
  base = [
    home-manager.nixosModules.home-manager
  ];

  hm = [
    ./module.nix
  ];
}
