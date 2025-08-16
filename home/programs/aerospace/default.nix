_: {
  programs.aerospace = {
    enable = true;

    launchd = {
      enable = true;
      keepAlive = true;
    };

    userSettings = {
      # NOTE: use colemak after home-manager fixes
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

      mode.main.binding = {
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";
      };
    };
  };
}
