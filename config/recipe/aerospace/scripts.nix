{
  aerospace-exe,
  jq-exe,
  lib,
  pkgs,
  scratchpad-apps,
  scratchpad-exe,
}: rec {
  scratchpad-toggle = pkgs.writeShellScript "aerospace-scratchpad-toggle" ''
    set -euo pipefail

    windows_json="$(${aerospace-exe} list-windows --all --json --format '%{app-bundle-id}%{tab}%{workspace}')"
    scratchpad_visible=false
    scratchpad_app_running=false

    app_is_running() {
      local app_id="$1"
      printf '%s\n' "$windows_json" |
        ${jq-exe} -e --arg app_id "$app_id" \
          'any(.[]; .["app-bundle-id"] == $app_id)' >/dev/null
    }

    app_is_visible() {
      local app_id="$1"
      printf '%s\n' "$windows_json" |
        ${jq-exe} -e --arg app_id "$app_id" \
          'any(.[]; .["app-bundle-id"] == $app_id and ((.workspace // "") | startswith(".scratchpad") | not))' >/dev/null
    }

    move_to_scratchpad() {
      local app_name="$1"
      if ! ${scratchpad-exe} move --all-matching "$app_name"; then
        printf '%s\n' "Failed to hide $app_name in the scratchpad." >&2
        return 1
      fi
    }

    show_from_scratchpad() {
      local app_name="$1"
      if ! ${scratchpad-exe} show "$app_name"; then
        printf '%s\n' "Failed to show $app_name from the scratchpad." >&2
        return 1
      fi
    }

    ${lib.concatMapStringsSep "\n" (
        app: ''
          if app_is_running ${lib.escapeShellArg app.app-id}; then
            scratchpad_app_running=true
          fi
          if app_is_visible ${lib.escapeShellArg app.app-id}; then
            scratchpad_visible=true
          fi
        ''
      )
      scratchpad-apps}

    if [ "$scratchpad_app_running" = false ]; then
      printf '%s\n' "No configured scratchpad applications are running." >&2
      exit 1
    fi

    if [ "$scratchpad_visible" = true ]; then
      ${lib.concatMapStringsSep "\n" (
        app: ''
          if app_is_running ${lib.escapeShellArg app.app-id}; then
            move_to_scratchpad ${lib.escapeShellArg app.app-name}
          fi
        ''
      )
      scratchpad-apps}
    else
      ${lib.concatMapStringsSep "\n" (
        app: ''
          if app_is_running ${lib.escapeShellArg app.app-id}; then
            show_from_scratchpad ${lib.escapeShellArg app.app-name}
          fi
        ''
      )
      scratchpad-apps}
    fi
  '';

  pip-handler = pkgs.writeShellScript "aerospace-pip-handler" ''
    set -euo pipefail

    PIP_WINDOW_ID="$(${aerospace-exe} list-windows --all --json \
      --format '%{window-title}%{tab}%{window-id}' |
      ${jq-exe} -r '
        first(
          .[]
          | select(.["window-title"] | test("Picture-in-Picture|화면 속 화면"))
          | .["window-id"]
        ) // empty
      '
    )"

    if [[ -z "$PIP_WINDOW_ID" ]]; then
      exit 0
    fi

    ${aerospace-exe} move-node-to-workspace --window-id "$PIP_WINDOW_ID" "$AEROSPACE_FOCUSED_WORKSPACE"
  '';

  workspace-change-handler = pkgs.writeShellScript "aerospace-workspace-change-handler" ''
    set -euo pipefail

    ${pip-handler} \
      >/tmp/pip-aerospace.out.log \
      2>/tmp/pip-aerospace.err.log
    ${scratchpad-exe} hook pull-window "$AEROSPACE_PREV_WORKSPACE" "$AEROSPACE_FOCUSED_WORKSPACE" \
      >/tmp/aerospace-scratchpad.out.log \
      2>/tmp/aerospace-scratchpad.err.log
  '';
}
