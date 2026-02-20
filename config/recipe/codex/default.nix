{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    # NOTE: npx requires nodejs in PATH environment
    nodejs_24
    # NOTE: codex prefer ripgrep
    ripgrep
  ];
  programs.codex = {
    enable = true;
    package = pkgs.llm-agents.codex;

    settings = {
      mcp_servers = {
        context7 = {
          command = "${lib.getExe' pkgs.nodejs_24 "npx"}";
          args = [
            "-y"
            "@upstash/context7-mcp"
          ];
        };
      };
      approval_policy = "on-request";
      runtime_metrics = true;
    };
  };
}
