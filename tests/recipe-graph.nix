{lib}: let
  recipeGraph = import ../lib/recipe-graph.nix {inherit lib;};
  module = name: _: {inherit name;};

  registry = {
    a = {
      includes = ["b" "c"];
      system = [(module "a-system-common")];
      home = [(module "a-home-common")];
      nixos = {
        system = [(module "a-system-nixos")];
        home = [(module "a-home-nixos")];
      };
      darwin = {
        system = [(module "a-system-darwin")];
        home = [(module "a-home-darwin")];
      };
    };
    b = {
      includes = ["d"];
      system = [(module "b-system-common")];
      home = [(module "b-home-common")];
    };
    c = {
      includes = ["d"];
      system = [(module "c-system-common")];
      home = [(module "c-home-common")];
      darwin = {
        system = [(module "c-system-darwin")];
        home = [(module "c-home-darwin")];
      };
    };
    d = {
      system = [(module "d-system-common")];
      home = [(module "d-home-common")];
    };
    darwin-only = {
      darwin = {
        system = [(module "darwin-only-system")];
        home = [(module "darwin-only-home")];
      };
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
  moduleNames = modules: map (recipeModule: (recipeModule {}).name) modules;
  backendModules = backend: (graph ["a"]).modulesForBackend backend;

  expectFailure = expression:
    assert !(builtins.tryEval (builtins.deepSeq expression true)).success; true;
in {
  ordering = assert (graph ["a"]).recipeNames == ["a" "b" "d" "c"];
  assert (graph ["c" "a"]).recipeNames == ["c" "d" "a" "b"]; true;

  sharedDependencyDeduplication = assert (graph ["a"]).recipeNames == ["a" "b" "d" "c"];
  assert builtins.length ((graph ["a"]).modulesForBackend "nixos").system == 5;
  assert builtins.length ((graph ["a"]).modulesForBackend "nixos").home == 5;
  assert builtins.all (recipeModule: builtins.typeOf recipeModule == "lambda") ((graph ["a"]).modulesForBackend "nixos").system;
  assert builtins.all (recipeModule: builtins.typeOf recipeModule == "lambda") ((graph ["a"]).modulesForBackend "nixos").home; true;

  nixosOrdering = let
    selected = backendModules "nixos";
  in
    assert moduleNames selected.system
    == [
      "a-system-common"
      "a-system-nixos"
      "b-system-common"
      "d-system-common"
      "c-system-common"
    ];
    assert moduleNames selected.home
    == [
      "a-home-common"
      "a-home-nixos"
      "b-home-common"
      "d-home-common"
      "c-home-common"
    ]; true;

  darwinOrdering = let
    selected = backendModules "darwin";
  in
    assert moduleNames selected.system
    == [
      "a-system-common"
      "a-system-darwin"
      "b-system-common"
      "d-system-common"
      "c-system-common"
      "c-system-darwin"
    ];
    assert moduleNames selected.home
    == [
      "a-home-common"
      "a-home-darwin"
      "b-home-common"
      "d-home-common"
      "c-home-common"
      "c-home-darwin"
    ]; true;

  backendOnly = let
    selected = (graph ["darwin-only"]).modulesForBackend "darwin";
    ignored = (graph ["darwin-only"]).modulesForBackend "nixos";
  in
    assert moduleNames selected.system == ["darwin-only-system"];
    assert moduleNames selected.home == ["darwin-only-home"];
    assert ignored.system == [];
    assert ignored.home == []; true;

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

  legacyDeclarationField = expectFailure (recipeGraph {
    roots = ["bad"];
    resolve = _: {systemModules = [(module "legacy")];};
  });

  nonListDeclarationField = expectFailure (recipeGraph {
    roots = ["bad"];
    resolve = _: {system = "not-a-list";};
  });

  nonStringInclude = expectFailure (recipeGraph {
    roots = ["bad"];
    resolve = _: {includes = ["valid" 42];};
  });

  nonFunctionModule = expectFailure (recipeGraph {
    roots = ["bad"];
    resolve = _: {system = [{}];};
  });

  nestedModuleList = expectFailure (recipeGraph {
    roots = ["bad"];
    resolve = _: {system = [[(module "nested")]];};
  });

  nonAttributeFragment = expectFailure (recipeGraph {
    roots = ["bad"];
    resolve = _: {nixos = [];};
  });

  unknownNestedField = expectFailure (recipeGraph {
    roots = ["bad"];
    resolve = _: {nixos = {typo = [];};};
  });

  nonFunctionNestedModule = expectFailure (recipeGraph {
    roots = ["bad"];
    resolve = _: {darwin = {home = [{}];};};
  });

  invalidBackend = expectFailure ((graph ["a"]).modulesForBackend "freebsd");

  dependencyCycle = expectFailure (graph ["cycle-a"]);
}
