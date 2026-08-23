{lib}: {
  roots,
  resolve,
}: let
  allowedFields = ["includes" "system" "home" "nixos" "darwin"];
  fragmentFields = ["system" "home"];
  declarationShape = "{ includes = [ ... ]; system = [ ... ]; home = [ ... ]; nixos = { system = [ ... ]; home = [ ... ]; }; darwin = { system = [ ... ]; home = [ ... ]; }; }";
  moduleTypes = ["lambda"];
  backends = ["nixos" "darwin"];

  firstInvalid = predicate: index: values:
    if values == []
    then null
    else let
      value = builtins.head values;
    in
      if predicate value
      then firstInvalid predicate (index + 1) (builtins.tail values)
      else {
        inherit index value;
      };

  validateList = recipeName: field: expected: predicate: value:
    if builtins.typeOf value != "list"
    then throw "Recipe '${recipeName}' field '${field}' expected a list of ${expected}; actual type '${builtins.typeOf value}'."
    else let
      invalid = firstInvalid predicate 0 value;
    in
      if invalid == null
      then value
      else throw "Recipe '${recipeName}' field '${field}[${toString invalid.index}]' expected ${expected}; actual type '${builtins.typeOf invalid.value}'.";

  validateIncludes = recipeName: field: value:
    validateList recipeName field "recipe-name strings" (item: builtins.typeOf item == "string") value;

  validateModules = recipeName: field: value:
    validateList recipeName field "function modules" (item: builtins.elem (builtins.typeOf item) moduleTypes) value;

  normalizeFragment = recipeName: field: fragment:
    if builtins.typeOf fragment != "set"
    then throw "Recipe '${recipeName}' field '${field}' expected an attribute set containing only 'system' and 'home' lists; actual type '${builtins.typeOf fragment}'."
    else let
      unknownFields = builtins.filter (nestedField: !(builtins.elem nestedField fragmentFields)) (builtins.attrNames fragment);
      unknownField =
        if unknownFields == []
        then null
        else builtins.head unknownFields;
      unknownFieldCheck =
        if unknownField == null
        then null
        else throw "Recipe '${recipeName}' field '${field}.${unknownField}' is unknown; expected one of ${lib.concatStringsSep ", " fragmentFields}; actual type '${builtins.typeOf (builtins.getAttr unknownField fragment)}'.";
      getField = nestedField:
        validateModules recipeName "${field}.${nestedField}" (
          if builtins.hasAttr nestedField fragment
          then builtins.getAttr nestedField fragment
          else []
        );
      system = getField "system";
      home = getField "home";
    in
      builtins.seq unknownFieldCheck
      (builtins.seq system
        (builtins.seq home {
          inherit system home;
        }));

  normalizeDeclaration = recipeName: declaration:
    if builtins.typeOf declaration != "set"
    then throw "Recipe '${recipeName}' field '<declaration>' expected ${declarationShape}; actual type '${builtins.typeOf declaration}'."
    else let
      unknownFields = builtins.filter (field: !(builtins.elem field allowedFields)) (builtins.attrNames declaration);
      unknownField =
        if unknownFields == []
        then null
        else builtins.head unknownFields;
      unknownFieldCheck =
        if unknownField == null
        then null
        else throw "Recipe '${recipeName}' field '${unknownField}' is unknown; expected one of ${lib.concatStringsSep ", " allowedFields}; actual type '${builtins.typeOf (builtins.getAttr unknownField declaration)}'.";
      getList = field: validator:
        validator recipeName field (
          if builtins.hasAttr field declaration
          then builtins.getAttr field declaration
          else []
        );
      includes = getList "includes" validateIncludes;
      system = getList "system" validateModules;
      home = getList "home" validateModules;
      nixos = normalizeFragment recipeName "nixos" (
        if builtins.hasAttr "nixos" declaration
        then declaration.nixos
        else {}
      );
      darwin = normalizeFragment recipeName "darwin" (
        if builtins.hasAttr "darwin" declaration
        then declaration.darwin
        else {}
      );
    in
      builtins.seq unknownFieldCheck
      (builtins.seq includes
        (builtins.seq system
          (builtins.seq home
            (builtins.seq nixos
              (builtins.seq darwin {
                inherit includes system home nixos darwin;
              })))));

  validateRoots =
    if builtins.typeOf roots != "list"
    then throw "Recipe graph field 'roots' expected a list of recipe-name strings; actual type '${builtins.typeOf roots}'."
    else let
      invalid = firstInvalid (value: builtins.typeOf value == "string") 0 roots;
    in
      if invalid == null
      then roots
      else throw "Recipe graph field 'roots[${toString invalid.index}]' expected a recipe-name string; actual type '${builtins.typeOf invalid.value}'.";

  resolver =
    if builtins.typeOf resolve == "lambda"
    then resolve
    else throw "Recipe graph field 'resolve' expected a resolver function; actual type '${builtins.typeOf resolve}'.";

  resolveDeclaration = path: name: let
    declaration = resolver name;
  in
    if declaration == null
    then
      if path == []
      then throw "Unknown root recipe '${name}': no declaration was returned; expected a recipe entrypoint."
      else throw "Unknown included recipe '${name}' while resolving '${lib.concatStringsSep " -> " (path ++ [name])}': no declaration was returned; expected a recipe entrypoint."
    else normalizeDeclaration name declaration;

  visit = path: visited: name:
    if builtins.elem name path
    then throw "Recipe dependency cycle detected: ${lib.concatStringsSep " -> " (path ++ [name])}"
    else if builtins.elem name visited
    then {
      inherit visited;
      recipes = [];
    }
    else let
      declaration = resolveDeclaration path name;
      descendants =
        builtins.foldl' (
          accumulated: includedName: let
            child = visit (path ++ [name]) accumulated.visited includedName;
          in {
            inherit (child) visited;
            recipes = accumulated.recipes ++ child.recipes;
          }
        ) {
          inherit visited;
          recipes = [];
        }
        declaration.includes;
    in {
      visited = [name] ++ descendants.visited;
      recipes = [{inherit name declaration;}] ++ descendants.recipes;
    };

  validatedRoots = validateRoots;
  traversal =
    builtins.foldl'
    (
      accumulated: root: let
        branch = visit [] accumulated.visited root;
      in {
        inherit (branch) visited;
        recipes = accumulated.recipes ++ branch.recipes;
      }
    )
    {
      visited = [];
      recipes = [];
    }
    validatedRoots;

  orderedRecipes = traversal.recipes;
  recipeNames = map (recipe: recipe.name) orderedRecipes;
  declarations = map (recipe: recipe.declaration) orderedRecipes;

  validateBackend = backend:
    if builtins.typeOf backend != "string"
    then throw "Recipe graph backend expected one of ${lib.concatStringsSep ", " backends}; actual type '${builtins.typeOf backend}'."
    else if !(builtins.elem backend backends)
    then throw "Recipe graph backend expected one of ${lib.concatStringsSep ", " backends}; actual value '${backend}'."
    else backend;

  modulesForBackend = backend: let
    selectedBackend = validateBackend backend;
    select = recipe: let
      inherit (recipe) declaration;
      fragment = builtins.getAttr selectedBackend declaration;
    in {
      system = declaration.system ++ fragment.system;
      home = declaration.home ++ fragment.home;
    };
    contributions = map select orderedRecipes;
  in {
    system = builtins.concatLists (map (contribution: contribution.system) contributions);
    home = builtins.concatLists (map (contribution: contribution.home) contributions);
  };
in
  builtins.seq validatedRoots {
    inherit recipeNames declarations modulesForBackend;
  }
