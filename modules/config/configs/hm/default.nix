{
  common = {
    config =
      {
        metadata,
        lib,
        home-manager,
        ...
      }:
      [
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "bak";
          home-manager.extraSpecialArgs = { inherit metadata; };
        }
      ]
      ++ lib.optional (metadata.distribution == "nixos") home-manager.nixosModules.home-manager
      ++ lib.optional (metadata.distribution == "macos") home-manager.darwinModules.home-manager
      ++ [
        {
          home-manager.users."${metadata.usernameLower}" = ./. + "../../../home/${metadata.distribution}.nix";
        }
      ];
  };
}
