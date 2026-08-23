{lib}: {
  roots,
  resolve,
}: let
  allowedFields = ["includes" "systemModules" "homeModules"];
  declarationShape = "{ includes = [ ... ]; systemModules = [ ... ]; homeModules = [ ... ]; }";
  moduleTypes = ["lambda"];

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
    then throw "Recipe '${recipeName}' field '${field}' expected ${expected}; actual type '${builtins.typeOf value}'."
    else let
      invalid = firstInvalid predicate 0 value;
    in
      if invalid == null
      then value
      else throw "Recipe '${recipeName}' field '${field}[${toString invalid.index}]' expected ${expected}; actual type '${builtins.typeOf invalid.value}'.";

  validateIncludes = recipeName: field: value:
    validateList recipeName field "a recipe-name string" (item: builtins.typeOf item == "string") value;

  validateModules = recipeName: field: value:
    validateList recipeName field "a function module" (item: builtins.elem (builtins.typeOf item) moduleTypes) value;

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
      getField = field: default: validator:
        validator recipeName field (
          if builtins.hasAttr field declaration
          then builtins.getAttr field declaration
          else default
        );
      includes = getField "includes" [] validateIncludes;
      systemModules = getField "systemModules" [] validateModules;
      homeModules = getField "homeModules" [] validateModules;
    in
      builtins.seq unknownFieldCheck
      (builtins.seq includes
        (builtins.seq systemModules
          (builtins.seq homeModules {
            inherit includes systemModules homeModules;
          })));

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
    builtins.foldl' (
      accumulated: root: let
        branch = visit [] accumulated.visited root;
      in {
        inherit (branch) visited;
        recipes = accumulated.recipes ++ branch.recipes;
      }
    ) {
      visited = [];
      recipes = [];
    }
    validatedRoots;

  orderedRecipes = traversal.recipes;
  recipeNames = map (recipe: recipe.name) orderedRecipes;
  declarations = map (recipe: recipe.declaration) orderedRecipes;
  systemModules = builtins.concatLists (map (recipe: recipe.declaration.systemModules) orderedRecipes);
  homeModules = builtins.concatLists (map (recipe: recipe.declaration.homeModules) orderedRecipes);
in
  builtins.seq validatedRoots {
    inherit recipeNames declarations systemModules homeModules;
  }
