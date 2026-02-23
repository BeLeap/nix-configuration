_: {
  hm = [
    (
      {config, pkgs, ...}: {
        home.packages = with pkgs; [
          # NOTE: codex prefer ripgrep
          ripgrep
        ];
        programs.codex = {
          enable = true;
          package = pkgs.llm-agents.codex;
          settings = {
            mcp_servers = {
              context7 = {
                url = "https://mcp.context7.com/mcp";
                # Secret file should contain the raw Context7 API key.
                env = {
                  CONTEXT7_API_KEY_FILE = config.age.secrets.context7-api-key.path;
                };
              };
            };
            approval_policy = "on-request";
            runtime_metrics = true;
          };
        };
      }
    )
  ];
}
