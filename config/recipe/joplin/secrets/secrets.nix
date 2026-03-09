let
  keys = import ../../../../lib/agenix/keys.nix;
in {
  "joplin-settings.age" = {
    publicKeys = [keys.beleap-m1air];
    armor = true;
  };
}
