{
  agenix,
  lib,
  metadata,
  ...
}: {
  hm = [
    (
      {
        config,
        pkgs,
        ...
      }: let
        focusCodexApproval = pkgs.writeShellApplication {
          name = "focus-codex-approval";
          runtimeInputs =
            [pkgs.tmux]
            ++ lib.optionals pkgs.stdenv.isDarwin [pkgs.aerospace];
          text = ''
            set -euo pipefail

            target="''${CODEX_TMUX_TARGET:-''${TMUX_PANE:-}}"

            terminal_workspace_is_focused() {
              [ "$(uname -s)" = "Darwin" ] || return 0
              [ "$(aerospace list-workspaces --focused 2>/dev/null || true)" = "1" ]
            }

            target_is_active() {
              [ -n "$target" ] || return 1
              [ "$(tmux display-message -p -t "$target" '#{window_active}:#{pane_active}' 2>/dev/null || true)" = "1:1" ]
            }

            if target_is_active && terminal_workspace_is_focused; then
              sleep_seconds=0
            else
              sleep_seconds=5
            fi

            if [ "$(uname -s)" = "Darwin" ]; then
              if [ "$sleep_seconds" -gt 0 ]; then
                /usr/bin/osascript \
                  -e 'display notification "Approval requested. Focusing Codex in 5 seconds." with title "Codex"' \
                  >/dev/null 2>&1 || true
              fi
            fi

            if [ "$sleep_seconds" -gt 0 ]; then
              sleep "$sleep_seconds"
            fi

            if [ -n "$target" ]; then
              window_target="$(tmux display-message -p -t "$target" '#S:#I' 2>/dev/null || true)"
              if [ -n "$window_target" ]; then
                tmux switch-client -t "$window_target" 2>/dev/null || true
                tmux select-window -t "$window_target" 2>/dev/null || true
              fi
              tmux select-pane -t "$target" 2>/dev/null || true
            else
              tmux select-window -t ":codex" 2>/dev/null || true
            fi

            if [ "$(uname -s)" = "Darwin" ]; then
              aerospace workspace 1 >/dev/null 2>&1 || true
            fi
          '';
        };
        codext = pkgs.writeTextFile rec {
          name = "codext";
          text = ''
            #! ${lib.getExe pkgs.python3}

            import json
            import os
            import sys
            from pathlib import Path


            def main() -> None:
                project = json.dumps(str(Path.cwd()))
                config = f'projects={{{project}={{trust_level="trusted"}}}}'
                os.execvp("codex", ["codex", "-c", config, *sys.argv[1:]])


            if __name__ == "__main__":
                main()
          '';
          executable = true;
          destination = "/bin/${name}";
        };
      in {
        imports = [(import ../../../lib/agenix/hm.nix {inherit agenix metadata;})];

        home.packages = with pkgs; [
          # NOTE: codex prefer ripgrep
          ripgrep
          codext
        ];
        home.file.".codex/rules/default.rules".source = ./rules/default.rules;
        age.secrets = {
          context7-api-key.file = ./secrets/context7-api-key.age;
        };
        programs.codex = {
          enable = true;
          package = pkgs.llm-agents.codex;
          settings = {
            model = "gpt-5.5";
            hide_agent_reasoning = false;

            mcp_servers = {
              context7 = {
                url = "https://mcp.context7.com/mcp";
                bearer_token_env_var = "CONTEXT7_API_KEY";
              };
            };

            approval_policy = "on-request";
            sandbox_mode = "workspace-write";

            runtime_metrics = true;

            hooks = {
              state = {
                "${config.home.homeDirectory}/.codex/config.toml:permission_request:0:0".trusted_hash = "sha256:e97584cd8c170a6dc8dd63f53d103c4f3de3b4fe3af30a0555393396d85c8d45";
              };

              PermissionRequest = [
                {
                  matcher = ".*";
                  hooks = [
                    {
                      type = "command";
                      command = "${lib.getExe focusCodexApproval}";
                      timeout = 10;
                      statusMessage = "Focusing Codex approval if needed";
                    }
                  ];
                }
              ];
            };

            tui = {
              notifications = [
                "approval-requested"
                "agent-turn-complete"
              ];

              status_line = [
                "model-with-reasoning"
                "context-remaining"
                "current-dir"
                "model-name"
                "git-branch"
                "context-used"
                "context-window-size"
                "used-tokens"
                "total-output-tokens"
                "five-hour-limit"
                "weekly-limit"
              ];
            };
          };
        };
        programs.zsh.initContent = lib.mkAfter ''
          if [ -f ${config.age.secrets."context7-api-key".path} ]; then
            export CONTEXT7_API_KEY="$(cat ${config.age.secrets."context7-api-key".path})"
          fi
        '';
      }
    )
  ];
}
