_: {
  hm = [
    (
      {pkgs, ...}: let
        wsCleanupScript = import ../script.nix {inherit pkgs;};
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
}
