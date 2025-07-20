_: {
  imports = [
    ./brew.nix
  ];

  security.pam.services.sudo_local.touchIdAuth = true;
}
