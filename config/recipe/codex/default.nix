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
      }: {
        imports = [(import ../../../lib/agenix/hm.nix {inherit agenix metadata;})];

        home.packages = with pkgs; [
          # NOTE: codex prefer ripgrep
          ripgrep
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

            tui = {
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
