_: {
  hm = [
    (
      {pkgs, ...}: let
        wsCleanupScript = import ../script.nix {inherit pkgs;};
      in {
        launchd.agents.ws-cleanup = {
          enable = true;
          config = {
            ProgramArguments = [
              "${pkgs.bash}/bin/bash"
              "${wsCleanupScript}"
            ];
            StartCalendarInterval = [
              {
                Hour = 4;
                Minute = 0;
              }
            ];
            StandardOutPath = "/tmp/ws-cleanup.out.log";
            StandardErrorPath = "/tmp/ws-cleanup.err.log";
          };
        };
      }
    )
  ];
}
