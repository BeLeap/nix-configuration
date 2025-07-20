{ username, ... }:
{
  imports = [
    ./brew.nix
  ];

  security.pam.services.sudo_local.touchIdAuth = true;

  users.users."${username}" = {
    home = "/Users/${username}";
  };
  system.primaryUser = username;
}
