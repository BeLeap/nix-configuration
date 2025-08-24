{ lib, ... }:
{
  programs.aerospace = {
    enable = true;

    launchd = {
      enable = true;
      keepAlive = true;
    };

    userSettings = {
      key-mapping = {
        preset = "colemak";
      };

      exec-on-workspace-change = [
        "/bin/bash"
        "-c"
        "aerospace move-node-to-workspace --window-id $(aerospace list-windows --all --format \"%{window-title}%{tab}%{window-id}\" | grep Picture-in-Picture | cut -f2 | tee /tmp/pip-window-id) $AEROSPACE_FOCUSED_WORKSPACE"
      ];

      mode.main.binding = {
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";
      }
      // lib.listToAttrs (
        (lib.flatten (
          lib.map (
            e:
            let
              index = toString e;
            in
            [
              {
                name = "alt-${index}";
                value = "workspace ${index}";
              }
              {
                name = "alt-shift-${index}";
                value = "move-node-to-workspace ${index}";
              }
            ]
          ) (lib.genList (x: x + 1) 9)
        ))
      );

      on-window-detected = [
        {
          check-further-callbacks = true;
          "if" = {
            window-title-regex-substring = "Picture-in-Picture";
          };
          run = [ "layout floating" ];
        }
        {
          check-further-callbacks = true;
          "if" = {
            app-id = "com.kakao.KakaoTalkMac";
          };
          run = [ "layout floating" ];
        }
        {
          check-further-callbacks = false;
          "if" = {
            app-id = "org.alacritty";
          };
          run = [ "move-node-to-workspace 2" ];
        }
        {
          check-further-callbacks = false;
          "if" = {
            app-id = "com.github.wez.wezterm";
          };
          run = [ "move-node-to-workspace 2" ];
        }
        {
          check-further-callbacks = false;
          "if" = {
            app-id = "org.mozilla.firefoxdeveloperedition";
          };
          run = [ "move-node-to-workspace 3" ];
        }
        {
          check-further-callbacks = false;
          "if" = {
            app-name-regex-substring = ".*";
          };
          run = [ "move-node-to-workspace 1" ];
        }
      ];
    };
  };
}
