{
  lib,
  metadata,
  home-manager,
}: {
  recipes =
    (lib.optionals (metadata.distribution == "macos") [
      "aerospace"
      "kdeconnect-mac"
    ])
    ++ (lib.optionals (metadata.distribution == "nixos" && metadata.gui) [
      "hyprland"
      "rofi"
      "waybar"
    ]);

  base =
    [
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "bak";
        home-manager.extraSpecialArgs = {inherit metadata;};
      }
    ]
    ++ lib.optional (metadata.distribution == "nixos") home-manager.nixosModules.home-manager
    ++ lib.optional (metadata.distribution == "macos") home-manager.darwinModules.home-manager;

  hm = [
    (
      if metadata.distribution == "macos"
      then ./macos.nix
      else ./nixos.nix
    )
  ];
}
