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
          runtimeInputs = [pkgs.tmux];
          text = ''
            set -euo pipefail

            target="''${CODEX_TMUX_TARGET:-''${TMUX_PANE:-}}"

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
              case "''${TERM_PROGRAM:-}" in
                Apple_Terminal)
                  /usr/bin/osascript -e 'tell application "Terminal" to activate' >/dev/null 2>&1 || true
                  ;;
                iTerm.app | iTerm2)
                  /usr/bin/osascript -e 'tell application "iTerm" to activate' >/dev/null 2>&1 || true
                  ;;
                WezTerm)
                  /usr/bin/osascript -e 'tell application "WezTerm" to activate' >/dev/null 2>&1 || true
                  ;;
                Ghostty | ghostty | "")
                  /usr/bin/osascript -e 'tell application "Ghostty" to activate' >/dev/null 2>&1 || true
                  ;;
              esac
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
                "${config.home.homeDirectory}/.codex/config.toml:permission_request:0:0".trusted_hash = "sha256:95abd7dbcaec8f7430f749de9e20d9cd9c45fbba75eb268c53d037a3444d5b24";
              };

              PermissionRequest = [
                {
                  matcher = ".*";
                  hooks = [
                    {
                      type = "command";
                      command = "${lib.getExe focusCodexApproval}";
                      timeout = 5;
                      statusMessage = "Focusing Codex approval";
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
