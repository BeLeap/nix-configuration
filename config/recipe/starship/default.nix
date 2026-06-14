_: {
  hm = [
    (
      {
        lib,
        pkgs,
        ...
      }: let
        customShell = ["sh"];
      in {
        programs.starship = {
          enable = true;

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
                git_branch = {
                  when = "! jj --ignore-working-copy root >/dev/null 2>&1";
                  command = "starship module git_branch";
                  shell = customShell;
                };
                jj_bookmark = {
                  when = "jj --ignore-working-copy root >/dev/null 2>&1 && test -n \"$(jj log --ignore-working-copy -r 'heads(::@ & bookmarks())' --color never --no-graph -T 'bookmarks.map(|b| b.name()).join(\" \")')\"";
                  symbol = "jjb";
                  command = ''
                    jj log --ignore-working-copy -r 'heads(::@ & bookmarks())' --color always --no-graph -T 'bookmarks.map(|b| b.name()).join(" ")'
                  '';
                  format = "\\[[$symbol $output]($style)\\]";
                  shell = customShell;
                };
                jj_workingcopy = {
                  when = "jj --ignore-working-copy root >/dev/null 2>&1";
                  symbol = "jjwc";
                  command = ''
                    jj log --ignore-working-copy -r @ --color always --no-graph -T 'change_id.shortest()'
                  '';
                  format = "\\[[$symbol $output]($style)\\]";
                  shell = customShell;
                };
                git_status = {
                  when = "! jj --ignore-working-copy root >/dev/null 2>&1";
                  command = "starship module git_status";
                  shell = customShell;
                };
                jj_status = {
                  when = ''jj --ignore-working-copy root >/dev/null 2>&1 && test -n "$(jj diff --summary --ignore-working-copy)"'';
                  symbol = "jjst";
                  command = ''
                    set -e

                    summary="$(jj diff --summary --ignore-working-copy)"

                    printf '%s\n' "$summary" | awk '
                      $1 == "M" { modified++ }
                      $1 == "A" { added++ }
                      $1 == "D" { deleted++ }
                      $1 == "R" { renamed++ }
                      END {
                        esc = sprintf("%c", 27)
                        sep = ""
                        if (modified) {
                          printf "%s%s[33mM%d%s[0m", sep, esc, modified, esc
                          sep = " "
                        }
                        if (added) {
                          printf "%s%s[32mA%d%s[0m", sep, esc, added, esc
                          sep = " "
                        }
                        if (deleted) {
                          printf "%s%s[31mD%d%s[0m", sep, esc, deleted, esc
                          sep = " "
                        }
                        if (renamed) {
                          printf "%s%s[34mR%d%s[0m", sep, esc, renamed, esc
                        }
                      }
                    '
                  '';
                  format = "\\[[$symbol $output]($style)\\]";
                  unsafe_no_escape = true;
                  shell = customShell;
                };
              };
            };
        };
      }
    )
  ];
}
