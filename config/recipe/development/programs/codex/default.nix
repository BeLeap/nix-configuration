{ pkgs, lib, ... }:
{
  # NOTE: npx requires nodejs in PATH environment
  home.packages = [
    pkgs.nodejs_24
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
