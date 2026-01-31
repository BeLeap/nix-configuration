let
  beleap = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqR0nOLKUM0sAeisBDdfgUhT0d/XzzArEi3I678XOND";
  users = [ beleap ];
in
{
  "some-secret.info.age" = {
    publicKeys = users;
    armor = true;
  };
}
