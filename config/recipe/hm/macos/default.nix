{home-manager, ...}: {
  base = [
    home-manager.darwinModules.home-manager
  ];

  hm = [
    ./module.nix
  ];
}
