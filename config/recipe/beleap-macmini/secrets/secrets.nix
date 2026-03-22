let
  keys = import ../../../../lib/agenix/keys.nix;
in {
  "discord-token.age" = {
    publicKeys = [keys.beleap-macmini];
    armor = true;
  };
}
