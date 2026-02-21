_: {
  hm = [
    (
      {
        pkgs,
        metadata,
        ...
      }: {
        home.packages = with pkgs; [
          podman
          podman-compose
        ];
        home.shellAliases = {
          docker = "podman";
        };
        launchd.agents."podman-machine-start" = {
          enable = metadata.os == "darwin";
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
}
