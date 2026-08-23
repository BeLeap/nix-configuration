_: {
  darwin = {
    home = [
      (
        {pkgs, ...}: let
          wsCleanupScript = import ./script.nix {inherit pkgs;};
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
  };

  nixos = {
    home = [
      (
        {pkgs, ...}: let
          wsCleanupScript = import ./script.nix {inherit pkgs;};
        in {
          systemd.user = {
            services.ws-cleanup = {
              Unit = {
                Description = "Clean up stale first-level workspace directories";
              };
              Service = {
                Type = "oneshot";
                ExecStart = "${wsCleanupScript}";
              };
            };
            timers.ws-cleanup = {
              Unit = {
                Description = "Run workspace cleanup regularly";
              };
              Timer = {
                OnBootSec = "10m";
                OnUnitActiveSec = "1d";
                Persistent = true;
              };
              Install = {
                WantedBy = ["timers.target"];
              };
            };
          };
        }
      )
    ];
  };
}
