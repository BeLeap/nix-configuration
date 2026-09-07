_: {
  darwin = {
    home = [
      (
        {
          inputs,
          lib,
          pkgs,
          ...
        }: let
          scratchpad = inputs.aerospace-scratchpad.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (_: {
            # v0.6.0 shipped with a stale source hash in its Nix expression.
            src = pkgs.fetchFromGitHub {
              owner = "cristianoliveira";
              repo = "aerospace-scratchpad";
              rev = "v0.6.0";
              hash = "sha256-BOy4wTvqWCgNxqKybLAl3iVe0T+P9Y9JcbupXb3KhyM=";
            };
            vendorHash = "sha256-jYCA3DNoi9Mj55t6ru76voENM8VSJt7Gp74JV7Vq19k=";
          });
          scratchpad-apps = [
            {
              app-id = "org.keepassxc.keepassxc";
              app-name = "KeePassXC";
            }
          ];
          scratchpad-toggle = pkgs.writeShellScript "aerospace-scratchpad-toggle" ''
            set -euo pipefail

            WINDOWS="$(${lib.getExe pkgs.unstable.aerospace} list-windows --all --json --format '%{app-bundle-id}%{tab}%{workspace}')"
            scratchpad_visible=false
            scratchpad_app_running=false

            ${lib.concatMapStringsSep "\n" (
                app: ''
                  if printf '%s\n' "$WINDOWS" | ${lib.getExe pkgs.jq} -e --arg app_id ${lib.escapeShellArg app.app-id} \
                    'any(.[]; .["app-bundle-id"] == $app_id)' >/dev/null; then
                    scratchpad_app_running=true
                  fi
                  if printf '%s\n' "$WINDOWS" | ${lib.getExe pkgs.jq} -e --arg app_id ${lib.escapeShellArg app.app-id} \
                    'any(.[]; .["app-bundle-id"] == $app_id and (.workspace | startswith(".scratchpad") | not))' >/dev/null; then
                    scratchpad_visible=true
                  fi
                ''
              )
              scratchpad-apps}

            if [ "$scratchpad_app_running" = false ]; then
              printf '%s\n' "No configured scratchpad applications are running." >&2
              exit 1
            fi

            if [ "$scratchpad_visible" = true ]; then
              ${lib.concatMapStringsSep "\n" (
                app: ''
                  if printf '%s\n' "$WINDOWS" | ${lib.getExe pkgs.jq} -e --arg app_id ${lib.escapeShellArg app.app-id} \
                    'any(.[]; .["app-bundle-id"] == $app_id)' >/dev/null; then
                    if ! ${lib.getExe' scratchpad "aerospace-scratchpad"} move --all-matching ${lib.escapeShellArg app.app-name}; then
                      printf '%s\n' "Failed to hide ${app.app-name} in the scratchpad." >&2
                      exit 1
                    fi
                  fi
                ''
              )
              scratchpad-apps}
            else
              ${lib.concatMapStringsSep "\n" (
                app: ''
                  if printf '%s\n' "$WINDOWS" | ${lib.getExe pkgs.jq} -e --arg app_id ${lib.escapeShellArg app.app-id} \
                    'any(.[]; .["app-bundle-id"] == $app_id)' >/dev/null; then
                    if ! ${lib.getExe' scratchpad "aerospace-scratchpad"} show ${lib.escapeShellArg app.app-name}; then
                      printf '%s\n' "Failed to show ${app.app-name} from the scratchpad." >&2
                      exit 1
                    fi
                  fi
                ''
              )
              scratchpad-apps}
            fi
          '';
          scratchpad-window-rules =
            lib.map (
              app: {
                check-further-callbacks = false;
                "if" = {
                  inherit (app) app-id;
                };
                run = [
                  "layout floating"
                  "exec-and-forget ${lib.getExe' scratchpad "aerospace-scratchpad"} move --all-matching ${lib.escapeShellArg app.app-name}"
                ];
              }
            )
            scratchpad-apps;
          pip-handler = pkgs.writeShellScript "aerospace-pip-handler" ''
            PIP_WINDOW_ID=$(${lib.getExe pkgs.unstable.aerospace} list-windows --all --format "%{window-title}%{tab}%{window-id}" | grep -E "Picture-in-Picture|화면 속 화면" | cut -f2)

            if [[ -z $PIP_WINDOW_ID ]]; then
              exit 0
            fi

            ${lib.getExe pkgs.unstable.aerospace} move-node-to-workspace --window-id "$PIP_WINDOW_ID" "$AEROSPACE_FOCUSED_WORKSPACE"
          '';
          workspace-change-handler = pkgs.writeShellScript "aerospace-workspace-change-handler" ''
            ${pip-handler} 1>/tmp/pip-aerospace.out.log 2>/tmp/pip-aerospace.err.log
            ${lib.getExe' scratchpad "aerospace-scratchpad"} hook pull-window "$AEROSPACE_PREV_WORKSPACE" "$AEROSPACE_FOCUSED_WORKSPACE" 1>/tmp/aerospace-scratchpad.out.log 2>/tmp/aerospace-scratchpad.err.log
          '';
        in {
          home.packages = [scratchpad];

          programs.aerospace = {
            enable = true;
            package = pkgs.unstable.aerospace;

            launchd = {
              enable = true;
              keepAlive = true;
            };

            settings = {
              default-root-container-layout = "tiles";

              key-mapping = {
                preset = "colemak";
              };

              exec-on-workspace-change = [
                "${workspace-change-handler}"
              ];

              mode.main.binding =
                {
                  alt-0 = "workspace 10";
                  alt-shift-s = "exec-and-forget ${scratchpad-toggle}";
                  alt-h = "focus left";
                  alt-j = "focus down";
                  alt-k = "focus up";
                  alt-l = "focus right";

                  alt-f = "layout floating";
                  alt-t = "layout tiling";
                  cmd-n = "exec-and-forget ${pkgs.beleap-utils}/bin/click-notification";
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

              on-window-detected =
                scratchpad-window-rules
                ++ [
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
                    run = ["move-node-to-workspace 3"];
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
                      app-id = "com.tinyspeck.slackmacgap";
                    };
                    run = ["move-node-to-workspace 10"];
                  }
                  {
                    check-further-callbacks = false;
                    "if" = {
                      app-id = "com.hnc.Discord";
                    };
                    run = ["move-node-to-workspace 10"];
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
  };
}
