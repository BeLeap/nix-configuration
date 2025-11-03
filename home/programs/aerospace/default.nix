{ lib, pkgs, ... }:
{
  programs.aerospace = {
    enable = true;

    # launchd = {
    #   enable = true;
    #   keepAlive = true;
    # };

    userSettings = {
      default-root-container-layout = "tiles";

      key-mapping = {
        preset = "qwerty";

        key-notation-to-key-code = {
          "q" = "q";
          "w" = "w";
          "f" = "e";
          "p" = "r";
          "g" = "t";
          "j" = "y";
          "l" = "u";
          "u" = "i";
          "y" = "o";
          "semicolon" = "p";
          "leftSquareBracket" = "leftSquareBracket";
          "rightSquareBracket" = "rightSquareBracket";
          "backslash" = "backslash";

          "a" = "a";
          "r" = "s";
          "s" = "d";
          "t" = "f";
          "d" = "g";
          "h" = "h";
          "n" = "j";
          "e" = "k";
          "i" = "l";
          "o" = "semicolon";
          "quote" = "quote";

          "z" = "z";
          "x" = "x";
          "c" = "c";
          "v" = "v";
          "b" = "b";
          "k" = "n";
          "m" = "m";
          "comma" = "comma";
          "period" = "period";
          "slash" = "slash";
        };
      };

      exec-on-workspace-change = [
        "${pkgs.beleap-utils}/bin/aerospace-workspace-change"
        "${pkgs.beleap-utils}/bin:${pkgs.aerospace}/bin"
      ];

      mode.main.binding = {
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";

        alt-enter = "exec-and-forget open -n ${pkgs.wezterm}/Applications/Wezterm.app";
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
            app-id = "com.github.wez.wezterm";
          };
          run = [ "move-node-to-workspace 1" ];
        }
        {
          check-further-callbacks = false;
          "if" = {
            app-id = "org.mozilla.firefoxdeveloperedition";
          };
          run = [ "move-node-to-workspace 2" ];
        }
        {
          check-further-callbacks = false;
          "if" = {
            window-title-regex-substring = "1Password";
          };
          run = [ "layout floating" ];
        }
        {
          check-further-callbacks = false;
          "if" = {
            app-name-regex-substring = ".*";
          };
          run = [ "move-node-to-workspace 9" ];
        }
      ];
    };
  };

  launchd = {
    agents = {
      aerospace = {
        enable = true;
        config = {
          Program = "${pkgs.aerospace}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace";
          KeepAlive = true;
          RunAtLoad = true;
          StandardOutPath = "/tmp/aerospace.log";
          StandardErrorPath = "/tmp/aerospace.err.log";
        };
      };
    };
  };
}
