_: {
  base = {pkgs, ...}: {
    programs.zsh.enable = true;
    environment.shells = [pkgs.zsh];

    programs.ssh = {
      knownHosts = {
        "github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };
    };

    time.timeZone = "Asia/Seoul";

    environment.systemPackages = with pkgs; [
      vim
      curl
      git
    ];
  };
  hm = [
    (
      {pkgs, ...}: {
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
