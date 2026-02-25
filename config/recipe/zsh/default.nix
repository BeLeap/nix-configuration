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
              local name bookmark repo_root repo_name workspace_base workspace_dir
              name="$1"
              bookmark="$2"

              repo_root=$(jj root 2>/dev/null) || {
                echo "jjws: not inside a jj repository"
                return 1
              }

              repo_name=$(basename "$repo_root")
              workspace_base="$HOME/ws/$repo_name"

              if [[ -z "$name" ]]; then
                echo "usage: jjws <name> [bookmark]"
                return 1
              fi

              if [[ -z "$bookmark" ]]; then
                bookmark=$(jj bookmark list --template 'name ++ "\n"' | fzf) || return 1
              fi

              if [[ -z "$bookmark" ]]; then
                echo "usage: jjws <name> [bookmark]"
                return 1
              fi

              workspace_dir="$workspace_base/$name"

              mkdir -p "$workspace_base" || {
                echo "jjws: failed to create workspace base: $workspace_base"
                return 1
              }

              jj workspace add "$workspace_dir" -r "$bookmark" && cd "$workspace_dir"
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
