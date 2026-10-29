{lib}: override: let
  base = {
    username = "BeLeap";
    email = "beleap@beleap.dev";
    recipes = [];
  };
  effective = base // override;
in
  effective
  // {
    usernameLower = lib.toLower effective.username;
    platform =
      if effective.backend == "darwin"
      then "${effective.arch}-darwin"
      else if builtins.elem effective.backend ["nixos" "home-manager"]
      then "${effective.arch}-linux"
      else throw "Unsupported host backend '${effective.backend}'; expected 'darwin', 'nixos', or 'home-manager'.";
  }
