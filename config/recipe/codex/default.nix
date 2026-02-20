_: {
  hm = [
    (
      { pkgs, ... }: {
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
