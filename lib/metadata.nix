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
    platform = "${effective.arch}-${effective.os}";
  }
