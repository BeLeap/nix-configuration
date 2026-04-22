_: {
  hm = [
    (_: {
      programs.tmux = {
        enable = true;

        prefix = "C-a";
        sensibleOnTop = true;
        keyMode = "vi";

        extraConfig = ''
          set -g allow-passthrough all
        '';
      };
    })
  ];
}
