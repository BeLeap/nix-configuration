{ pkgs, ... }:
{
  # NOTE: npx requires nodejs in PATH environment
  home.packages = [
    pkgs.nodejs_24
  ];
  programs.codex = {
    enable = true;
    package = pkgs.unstable.codex;

    settings = {
      mcp_servers = {
        context7 = {
          command = "${pkgs.nodejs_24}/bin/npx";
          args = [
            "-y"
            "@upstash/context7-mcp"
          ];
        };
      };
    };
  };
}
