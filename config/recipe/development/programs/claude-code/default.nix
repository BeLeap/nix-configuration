{
  pkgs,
  lib,
  metadata,
  ...
}:
lib.optionalAttrs (metadata.kind == "work") {
  home.packages = [ pkgs.unstable.claude-code ];
  home.file = {
    ".claude/settings.json".text = builtins.toJSON {
      hooks = {
        Notification = [
          {
            matcher = "permission_prompt";
            hooks =
              [ ]
              ++ (lib.optional (metadata.distribution == "macos") {
                type = "command";
                command = "${lib.getExe pkgs.terminal-notifier} -title 'Claude Code' -message 'Needs permission'";

              });
          }
        ];
      };
    };
  };
}
