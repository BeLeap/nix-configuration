{host, ...}: {
  system = [
    ({pkgs, ...}: {
      programs.zsh.enable = true;

      users.users."${host.usernameLower}".shell = pkgs.zsh;
    })
  ];

  home = [
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

            # Interactive programs such as pi leave their OSC title behind.
            # Restore the shell title whenever the prompt returns.
            autoload -Uz add-zsh-hook
            set-shell-terminal-title() {
              printf '\e]0;%s\a' "''${PWD:t}"
            }
            add-zsh-hook precmd set-shell-terminal-title

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

            jws() {
              local panes workspace_name workspace_dir

              if [[ -z "''${WEZTERM_PANE:-}" ]]; then
                echo "jws: not running inside a WezTerm pane" >&2
                return 1
              fi

              if ! panes=$(wezterm cli list --format json); then
                echo "jws: failed to list WezTerm panes" >&2
                return 1
              fi

              if ! workspace_name=$(printf '%s\n' "$panes" | jq -r --arg pane "$WEZTERM_PANE" \
                'first(.[] | select((.pane_id | tostring) == $pane) | .workspace) // empty'); then
                echo "jws: failed to determine the current workspace" >&2
                return 1
              fi

              if [[ -z "$workspace_name" ]]; then
                echo "jws: current workspace was not found for pane $WEZTERM_PANE" >&2
                return 1
              fi

              workspace_dir="$HOME/ws/$workspace_name"
              if [[ ! -d "$workspace_dir" ]]; then
                echo "jws: workspace directory does not exist: $workspace_dir" >&2
                return 1
              fi

              cd -- "$workspace_dir"
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
