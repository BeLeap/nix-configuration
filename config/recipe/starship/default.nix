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
              git_commit = {
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
                  when = "jj --ignore-working-copy root";
                  command = ''
                    jj log --revisions @ --limit 1 --ignore-working-copy --no-graph --color always --template '
                      separate(" ",
                        bookmarks.map(|x| truncate_end(10, x.name(), "…")).join(" "),
                        tags.map(|x| truncate_end(10, x.name(), "…")).join(" "),
                        surround("\"", "\"", truncate_end(24, description.first_line(), "…")),
                        if(conflict, "conflict"),
                        if(divergent, "divergent"),
                        if(hidden, "hidden"),
                      )
                    '
                  '';
                  format = "\\[[$output]($style)\\]";
                };
                jjstate = {
                  when = "jj --ignore-working-copy root";
                  command = ''
                    jj log -r@ -n1 --ignore-working-copy --no-graph -T "" --stat | tail -n1 | ${lib.getExe pkgs.sd} "(\d+) files? changed, (\d+) insertions?\(\+\), (\d+) deletions?\(-\)" ' ''${1}c ''${2}i ''${3}d' | ${lib.getExe pkgs.sd} " 0." ""
                  '';
                  format = "\\[[$output]($style)\\]";
                };
              };
            };
        };
      }
    )
  ];
}
