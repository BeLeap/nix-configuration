{ metadata, pkgs, ... }:
{
  imports = [
    (import ./brew.nix { inherit metadata; })
  ];

  security.pam.services.sudo_local.touchIdAuth = true;

  users.users."${metadata.usernameLower}" = {
    home = "/Users/${metadata.usernameLower}";
    shell = pkgs.zsh;
  };
  system.primaryUser = metadata.usernameLower;
  environment.shells = [ pkgs.zsh ];
}
