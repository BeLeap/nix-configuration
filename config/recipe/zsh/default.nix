_: {
  hm = [
    (
      _: {
        programs.zsh = {
          enable = true;

          autocd = true;

          autosuggestion = {
            enable = true;
          };
          syntaxHighlighting = {
            enable = true;
          };

          initContent = ''
            # Safety
            setopt noclobber nomatch

            # Directory convenience
            setopt autocd chase_links
            setopt pushd_ignore_dups pushd_silent pushd_to_home

            # History behavior
            setopt share_history inc_append_history
            setopt hist_ignore_dups hist_ignore_space

            # Globbing
            setopt extended_glob

            # Spell-check
            # setopt correct_all

            bindkey -v

            fcd() {
              local file
              local dir
              file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
            }

            fe() {
              local file
              local editor
              file=$(fzf +m -q "$1") || return
              editor="''${EDITOR:-''${VISUAL:-vi}}"
              "$editor" "$file"
            }

            jjws() {
              local feature repo_root repo_name workspace_base workspace_dir revision
              feature="$1"
              revision="''${2:-master}"

              if [[ -z "$feature" ]]; then
                echo "usage: jjws <feature-name> [revision]"
                return 1
              fi

              repo_root=$(jj root 2>/dev/null) || {
                echo "jjws: not inside a jj repository"
                return 1
              }

              repo_name=$(basename "$repo_root")
              workspace_base="''${TMPDIR:-/tmp}/$repo_name"
              workspace_dir="$workspace_base/$feature"

              mkdir -p "$workspace_base" || {
                echo "jjws: failed to create workspace base: $workspace_base"
                return 1
              }

              jj workspace add "$workspace_dir" -r "$revision" && cd "$workspace_dir"
            }
          '';

          shellAliases = {
            sozsh = "source ~/.zshrc";
          };
        };
      }
    )
  ];
}
