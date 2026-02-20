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
              right_format = "$kubernetes";

              kubernetes.disabled = false;

              shlvl.disabled = false;
              shlvl.threshold = 2;
              shlvl.format = "\\[[$shlvl]($style)\\]";

              os.disabled = false;
            };
        };
      }
    )
  ];
}
