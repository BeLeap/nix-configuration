let
  keys = import ../../../../lib/agenix/keys.nix;
in {
  "joplin-api-token.age" = {
    publicKeys = [keys.beleap-m1air];
    armor = true;
  };
}
