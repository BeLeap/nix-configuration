_: {
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

        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";

        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
      };

      on-window-detected = [
        {
          check-further-callbacks = true;
          "if" = {
            window-title-regex-substring = "Picture-in-Picture";
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
            during-aerospace-startup = true;
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
