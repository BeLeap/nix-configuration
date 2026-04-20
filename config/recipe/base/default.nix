{
  lib,
  metadata,
  ...
}: {
  base = {pkgs, ...}: {
    programs.bash.enable = true;
    programs.fish.enable = true;
    environment.shells = [pkgs.bash pkgs.fish];

    users.users."${metadata.usernameLower}" = {
      shell = pkgs.fish;

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqR0nOLKUM0sAeisBDdfgUhT0d/XzzArEi3I678XOND"
      ];
    };

    programs.ssh = {
      knownHosts = {
        "github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };
    };

    time.timeZone = "Asia/Seoul";

    environment.systemPackages = with pkgs;
      [
        vim
        curl
        git
      ]
      ++ lib.optionals (metadata.distribution == "nixos") [
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
  };
  hm = [
    (
      {pkgs, ...}: {
        home.packages = with pkgs; [
          qbittorrent
        ];

        programs.tealdeer = {
          enable = true;

          settings = {
            updates = {
              tls_backend = "rustls-with-native-roots";
            };
          };
        };
      }
    )
  ];
}
