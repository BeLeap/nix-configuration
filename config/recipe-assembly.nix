{
  inputs,
  host,
  backend,
}: let
  lib = inputs.nixpkgs.lib;
  modules = import ./recipe-modules.nix {inherit inputs host backend;};

  # Compatibility ordering is preorder depth-first traversal: roots retain
  # host order, each recipe precedes its includes, includes retain declaration
  # order, and the first occurrence wins. Module precedence must use explicit
  # Nix module priorities rather than relying on this graph order.
  homeManagerModule = {
    home-manager.users."${host.usernameLower}" = {
      imports = modules.home;
    };
  };
in
  modules.system
  ++ lib.optional (modules.home != []) homeManagerModule
