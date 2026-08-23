{
  inputs,
  host,
}: let
  lib = inputs.nixpkgs.lib;
  callRecipe = entrypoint: let
    recipe = import entrypoint;
    actualType = builtins.typeOf recipe;
  in
    if actualType != "lambda"
    then throw "Recipe entrypoint '${toString entrypoint}' must be a function; actual type '${actualType}'."
    else recipe {inherit inputs host;};
  recipeGraph = import ../lib/recipe-graph.nix {inherit lib;};

  resolveRecipe = name: let
    entrypoint = ./. + "/recipe/${name}/default.nix";
  in
    if builtins.pathExists entrypoint
    then callRecipe entrypoint
    else throw "Recipe '${name}' is missing its entrypoint at '${toString entrypoint}'.";

  graph = recipeGraph {
    roots = host.recipes;
    resolve = resolveRecipe;
  };

  # Compatibility ordering is preorder depth-first traversal: roots retain
  # host order, each recipe precedes its includes, includes retain declaration
  # order, and the first occurrence wins. Module precedence must use explicit
  # Nix module priorities rather than relying on this graph order.
  homeManagerModule = {
    home-manager.users."${host.usernameLower}" = {
      imports = graph.homeModules;
    };
  };
in
  graph.systemModules
  ++ lib.optional (graph.homeModules != []) homeManagerModule
