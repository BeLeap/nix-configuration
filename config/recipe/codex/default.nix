{lib, ...}: {
  hm = [
    (
      {
        config,
        pkgs,
        ...
      }: {
        imports = [../../lib/agenix/hm.nix];

        home.packages = with pkgs; [
          # NOTE: codex prefer ripgrep
          ripgrep
        ];
        age.secrets = {
          context7-api-key.file = ./secrets/context7-api-key.age;
        };
        programs.codex = {
          enable = true;
          package = pkgs.llm-agents.codex;
          settings = {
            mcp_servers = {
              context7 = {
                url = "https://mcp.context7.com/mcp";
                bearer_token_env_var = "CONTEXT7_API_KEY";
              };
            };
            approval_policy = "on-request";
            runtime_metrics = true;
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
