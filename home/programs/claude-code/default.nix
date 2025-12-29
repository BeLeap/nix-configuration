{
  pkgs,
  lib,
  metadata,
  ...
}:
lib.optionalAttrs (metadata.kind == "work") {
  home.packages = [ pkgs.claude-code ];
  home.file = {
    ".claude/settings.json".text = builtins.toJSON {
      hooks = {
        Notification = [
          {
            matcher = "permission_prompt";
            hooks = [
              {
                type = "command";
                command = "${pkgs.terminal-notifier} -title 'Claude Code' -message 'Needs permission'";
              }
            ];
          }
        ];
      };
    };
  };
}
