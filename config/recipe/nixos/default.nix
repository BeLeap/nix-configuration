{
  lib,
  metadata,
}: {
  base = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      nftables
      bcc
      bind
      bpftrace
      ethtool
      iproute2
      lsof
      procps
      strace
      tcpdump
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
