{
  lib,
  metadata,
}: {
  base = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      nftables
    ];

    security.polkit.enable = true;

    users.groups.beleap = {};
    users.users."${metadata.usernameLower}" = {
      isNormalUser = true;
      home = "/home/${metadata.usernameLower}";
      group = "beleap";
      extraGroups = ["wheel"];
    };
  };
  hm = [
    (_: {
      xdg.userDirs = {
        enable = true;
        createDirectories = true;
      };
    })
  ];
}
