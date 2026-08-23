{
  inputs,
  lib,
}: hosts: let
  mkSystem = import ./mkSystem.nix {inherit inputs lib;};
in
  lib.foldr
  (host: acc: let
    system = mkSystem {inherit host;};
  in {
    nixosConfigurations = acc.nixosConfigurations // system.nixosConfigurations;
    darwinConfigurations = acc.darwinConfigurations // system.darwinConfigurations;
  })
  {
    nixosConfigurations = {};
    darwinConfigurations = {};
  }
  hosts
