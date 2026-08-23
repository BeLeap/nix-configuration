{host, ...}: {
  includes = [
    "hm/nixos"
    "nix/nixos"
    "nh/nixos"
    "ws-cleanup/nixos"
  ];

  nixos = {
    system = [
      ({pkgs, ...}: {
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
        users.users."${host.usernameLower}" = {
          isNormalUser = true;
          home = "/home/${host.usernameLower}";
          group = "beleap";
          extraGroups = ["wheel"];
        };
      })
    ];
    home = [
      (_: {
        xdg.userDirs = {
          enable = true;
          createDirectories = true;
        };
      })
    ];
  };
}
