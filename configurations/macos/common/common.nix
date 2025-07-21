{ metadata, ... }:
{
  imports = [
    ./brew.nix
  ];

  security.pam.services.sudo_local.touchIdAuth = true;

  users.users."${metadata.usernameLower}" = {
    home = "/Users/${metadata.usernameLower}";
  };
  system.primaryUser = metadata.usernameLower;
}
