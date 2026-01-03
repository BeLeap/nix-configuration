{ lib, metadata }:
(lib.optionalAttrs (metadata.distribution == "nixos") {
  base =
    { pkgs, ... }:
    {
      security.polkit.enable = true;

      users.groups.beleap = { };
      users.users."${metadata.usernameLower}" = {
        isNormalUser = true;
        home = "/home/${metadata.usernameLower}";
        group = "beleap";
        extraGroups = [ "wheel" ];
        shell = pkgs.zsh;

        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNrBVLG52+DGp9mHdt5H45alxWVCLu5JsodOPryPar5R620vqryWONGsE9FI8EeFRiBvIvNhhvYlbTzaSYU46koVRAUcjFUH3Wd3NW15sY4UiC9RYVMMtc0IpghSTa0cPH06XvU0d8cftySfarsT6rlJPLDpOKKn0yrbfI3ErncLpIWyBIYELkzJ3azeb4J8L2KoO+l4Ce4QR7E1eyqRXOPT81ZwK19mTW/F+H+UAlcQrv5uUh3NZclmahE3Vwc23VWORwmBvHnhcZSOb/M79lk45WVUFZYPBqSPxihNd9Cpcq7TgKczS1liiO2S2NIJ73wG/UviuR52fOqBagJBlL"
        ];
      };
    };
  hm = {
    imports = [ ./home.nix ];
  };
})
