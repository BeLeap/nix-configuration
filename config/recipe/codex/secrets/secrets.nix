let
  keys = import ../../../../lib/agenix/keys.nix;
in {
  "context7-api-key.age" = {
    publicKeys = [keys.beleap-m1air];
    armor = true;
  };
}
