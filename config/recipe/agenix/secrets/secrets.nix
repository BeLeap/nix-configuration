let
  keys = import ../../../../lib/agenix/keys.nix;
in {
  "some-secret.age" = {
    publicKeys = [keys.beleap-m1air];
    armor = true;
  };
}
