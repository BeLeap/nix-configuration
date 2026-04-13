_: {
  hm = [
    (
      {
        lib,
        pkgs,
        ...
      }: let
        pip-handler = pkgs.writeShellScript "aerospace-pip-handler" ''
          PIP_WINDOW_ID=$(${lib.getExe pkgs.aerospace} list-windows --all --format "%{window-title}%{tab}%{window-id}" | grep -E "Picture-in-Picture|화면 속 화면" | cut -f2)

          if [[ -z $PIP_WINDOW_ID ]]; then
            exit 0
          fi

          ${lib.getExe pkgs.aerospace} move-node-to-workspace --window-id "$PIP_WINDOW_ID" "$AEROSPACE_FOCUSED_WORKSPACE"
        '';
        workspace-change-handler = pkgs.writeShellScript "aerospace-workspace-change-handler" ''
          ${pip-handler} 1>/tmp/pip-aerospace.out.log 2>/tmp/pip-aerospace.err.log
        '';
      in {
        programs.aerospace = {
          enable = true;

          launchd = {
            enable = true;
            keepAlive = true;
          };

          userSettings = {
            default-root-container-layout = "tiles";

            key-mapping = {
              preset = "colemak";
            };

            exec-on-workspace-change = [
              "${workspace-change-handler}"
            ];

            mode.main.binding =
              {
                alt-h = "focus left";
                alt-j = "focus down";
                alt-k = "focus up";
                alt-l = "focus right";

                alt-f = "layout floating";
                alt-t = "layout tiling";

                alt-enter = "exec-and-forget open -n ${pkgs.wezterm}/Applications/Wezterm.app";
              }
              // lib.listToAttrs (lib.flatten (
                lib.map (
                  e: let
                    index = toString e;
                  in [
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
              ));

            on-window-detected = [
              {
                check-further-callbacks = true;
                "if" = {
                  window-title-regex-substring = "Picture-in-Picture|화면 속 화면";
                };
                run = ["layout floating"];
              }
              {
                check-further-callbacks = true;
                "if" = {
                  app-id = "com.kakao.KakaoTalkMac";
                };
                run = ["layout floating"];
              }
              {
                check-further-callbacks = true;
                "if" = {
                  app-id = "org.virtualbox.app.VirtualBoxVM";
                };
                run = ["layout floating"];
              }
              {
                check-further-callbacks = false;
                "if" = {
                  app-id = "com.github.wez.wezterm";
                };
                run = ["move-node-to-workspace 1"];
              }
              {
                check-further-callbacks = false;
                "if" = {
                  app-id = "com.apple.Safari";
                };
                run = ["move-node-to-workspace 2"];
              }
              {
                check-further-callbacks = false;
                "if" = {
                  app-id = "org.nixos.firefox";
                };
                run = ["move-node-to-workspace 2"];
              }
              {
                check-further-callbacks = false;
                "if" = {
                  app-id = "com.google.Chrome";
                };
                run = ["move-node-to-workspace 2"];
              }
              {
                check-further-callbacks = false;
                "if" = {
                  app-id = "net.cozic.joplin-desktop";
                };
                run = ["move-node-to-workspace 3"];
              }
              {
                check-further-callbacks = false;
                "if" = {
                  app-id = "notion.id";
                };
                run = ["move-node-to-workspace 3"];
              }
              {
                check-further-callbacks = false;
                "if" = {
                  window-title-regex-substring = "1Password";
                };
                run = ["layout floating"];
              }
              {
                check-further-callbacks = false;
                "if" = {
                  app-name-regex-substring = ".*";
                };
                run = ["move-node-to-workspace 9"];
              }
            ];
          };
        };
      }
    )
  ];
}
