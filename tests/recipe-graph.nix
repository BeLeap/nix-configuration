{lib}: let
  recipeGraph = import ../lib/recipe-graph.nix {inherit lib;};

  registry = {
    a = {
      includes = ["b" "c"];
      systemModules = [(_: {name = "a";})];
      homeModules = [(_: {name = "a-home";})];
    };
    b = {
      includes = ["d"];
      systemModules = [(_: {name = "b";})];
      homeModules = [(_: {name = "b-home";})];
    };
    c = {
      includes = ["d"];
      systemModules = [(_: {name = "c";})];
      homeModules = [(_: {name = "c-home";})];
    };
    d = {
      systemModules = [(_: {name = "d";})];
      homeModules = [(_: {name = "d-home";})];
    };
    cycle-a = {includes = ["cycle-b"];};
    cycle-b = {includes = ["cycle-c"];};
    cycle-c = {includes = ["cycle-a"];};
    unknown-parent = {includes = ["missing-child"];};
  };

  resolve = name:
    if builtins.hasAttr name registry
    then builtins.getAttr name registry
    else null;
  graph = roots: recipeGraph {inherit roots resolve;};

  expectFailure = expression:
    assert !(builtins.tryEval (builtins.deepSeq expression true)).success; true;
in {
  ordering = assert (graph ["a"]).recipeNames == ["a" "b" "d" "c"];
  assert (graph ["c" "a"]).recipeNames == ["c" "d" "a" "b"]; true;

  sharedDependencyDeduplication = assert (graph ["a"]).recipeNames == ["a" "b" "d" "c"];
  assert builtins.length (graph ["a"]).systemModules == 4;
  assert builtins.length (graph ["a"]).homeModules == 4;
  assert builtins.all (module: builtins.typeOf module == "lambda") (graph ["a"]).systemModules;
  assert builtins.all (module: builtins.typeOf module == "lambda") (graph ["a"]).homeModules; true;

  nonFunctionResolver = expectFailure (recipeGraph {
    roots = ["a"];
    resolve = registry;
  });

  unknownRoot = expectFailure (graph ["missing-root"]);
  unknownIncluded = expectFailure (graph ["unknown-parent"]);

  unknownDeclarationField = expectFailure (recipeGraph {
    roots = ["bad"];
    resolve = _: {typo = [];};
  });

  nonListDeclarationField = expectFailure (recipeGraph {
    roots = ["bad"];
    resolve = _: {includes = "not-a-list";};
  });

  nonStringInclude = expectFailure (recipeGraph {
    roots = ["bad"];
    resolve = _: {includes = ["valid" 42];};
  });

  nonFunctionModule = expectFailure (recipeGraph {
    roots = ["bad"];
    resolve = _: {systemModules = [{}];};
  });

  nestedModuleList = expectFailure (recipeGraph {
    roots = ["bad"];
    resolve = _: {systemModules = [[(_: {})]];};
  });

  dependencyCycle = expectFailure (graph ["cycle-a"]);
}
