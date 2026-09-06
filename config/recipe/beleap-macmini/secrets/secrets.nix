let
  keys = import ../../../../lib/agenix/keys.nix;
in {
  "github-runner-token.age" = {
    publicKeys = [keys.beleap-macmini];
    armor = true;
  };
}
