_: {
  hm = [
    (
      {pkgs, ...}: {
        home.packages = with pkgs; [
          # NOTE: codex prefer ripgrep
          ripgrep
          nodejs
        ];
        programs.codex = {
          enable = true;
          package = pkgs.llm-agents.codex;
          settings = {
            mcp_servers = {
              context7 = {
                url = "https://mcp.context7.com/mcp";
              };
              playwright = {
                command = "npx";
                args = [
                  "-y"
                  "@playwright/mcp@latest"
                ];
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
