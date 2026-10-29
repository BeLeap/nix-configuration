{lib}: override: let
  base = {
    username = "BeLeap";
    email = "beleap@beleap.dev";
    recipes = [];
  };
  effective = base // override;
  standalonePlatform = effective.platform or null;
  platform =
    if effective.backend == "darwin"
    then "${effective.arch}-darwin"
    else if effective.backend == "nixos"
    then "${effective.arch}-linux"
    else if effective.backend == "home-manager"
    then
      if builtins.typeOf standalonePlatform != "string"
      then throw "Home Manager-only host '${effective.name}' must set an explicit 'platform' such as 'x86_64-linux'."
      else if lib.hasSuffix "-linux" standalonePlatform || lib.hasSuffix "-darwin" standalonePlatform
      then standalonePlatform
      else throw "Home Manager-only host '${effective.name}' platform must end in '-linux' or '-darwin'; got '${standalonePlatform}'."
    else throw "Unsupported host backend '${effective.backend}'; expected 'darwin', 'nixos', or 'home-manager'.";
in
  effective
  // {
    usernameLower = lib.toLower effective.username;
    inherit platform;
  }
