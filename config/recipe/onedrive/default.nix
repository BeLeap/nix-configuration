_: {
  hm = [
    ({
      config,
      pkgs,
      lib,
      ...
    }: {
      programs.rclone = {
        enable = true;
      };
      launchd.agents.onedrive-rclone = {
        enable = true;
        config = {
          Program = lib.getExe pkgs.rclone;
          ProgramArguments = ["nfsmount" "OneDrive:" "${config.home.homeDirectory}/OneDrive"];
          KeepAlive = true;
          RunAtLoad = true;
          StandardOutPath = "/tmp/onedrive-rclone.log";
          StandardErrorPath = "/tmp/onedrive-rclone.log";
        };
      };
    })
  ];
}
