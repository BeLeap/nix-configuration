_: {
  hm = [
    (
      {
        lib,
        pkgs,
        ...
      }: {
        programs.starship = {
          enable = true;

          enableZshIntegration = true;
          enableBashIntegration = true;
          enableNushellIntegration = true;

          settings =
            lib.recursiveUpdate
            (
              with builtins; (fromTOML (readFile "${pkgs.starship}/share/starship/presets/bracketed-segments.toml"))
            )
            {
              scan_timeout = 1;

              right_format = "$kubernetes";

              kubernetes = {
                disabled = false;
              };

              git_branch = {
                disabled = true;
              };
              git_status = {
                disabled = true;
              };

              shlvl = {
                disabled = false;
                threshold = 2;
                format = "\\[[$shlvl]($style)\\]";
              };

              os = {
                disabled = false;
              };

              custom = {
                jj = {
                  when = "${lib.getExe pkgs.jj-starship} detect";
                  shell = ["${lib.getExe pkgs.jj-starship}"];
                  format = "[$output]";
                };
              };
            };
        };
      }
    )
  ];
}
