{ lib, ... }:
{
  programs.aerospace = {
    enable = true;

    launchd = {
      enable = true;
      keepAlive = true;
    };

    userSettings = {
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
      // builtins.listToAttrs (
        (lib.flatten (
          lib.map
            (e: [
              {
                name = "alt-${e}";
                value = "workspace ${e}";
              }
              {
                name = "alt-shift-${e}";
                value = "move-node-to-workspace ${e}";
              }
            ])
            [
              "1"
              "2"
              "3"
              "4"
            ]
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
    }
    # NOTE: use colemak after home-manager fixes
    // {
      key-mapping = {
        preset = "qwerty";
      };
      key-mapping.key-notation-to-key-code = {
        q = "q";
        w = "w";
        f = "e";
        p = "r";
        g = "t";
        j = "y";
        l = "u";
        u = "i";
        y = "o";
        semicolon = "p";
        leftSquareBracket = "leftSquareBracket";
        rightSquareBracket = "rightSquareBracket";
        backslash = "backslash";

        a = "a";
        r = "s";
        s = "d";
        t = "f";
        d = "g";
        h = "h";
        n = "j";
        e = "k";
        i = "l";
        o = "semicolon";
        quote = "quote";

        z = "z";
        x = "x";
        c = "c";
        v = "v";
        b = "b";
        k = "n";
        m = "m";
        comma = "comma";
        period = "period";
        slash = "slash";
      };
    };
  };
}
