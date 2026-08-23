_: {
  home = [
    (
      {pkgs, ...}: {
        home.packages = with pkgs; [
          podman
          podman-compose
        ];
        home.shellAliases = {
          docker = "podman";
        };
      }
    )
  ];

  darwin = {
    home = [
      (
        {pkgs, ...}: {
          launchd.agents."podman-machine-start" = {
            enable = true;
            config = {
              ProgramArguments = [
                "${pkgs.podman}/bin/podman"
                "machine"
                "start"
              ];
              RunAtLoad = true;
              StandardOutPath = "/tmp/podman-machine-start.out.log";
              StandardErrorPath = "/tmp/podman-machine-start.err.log";
            };
          };
        }
      )
    ];
  };
}
