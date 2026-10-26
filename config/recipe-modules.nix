{
  inputs,
  host,
  backend,
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
in
  graph.modulesForBackend backend
