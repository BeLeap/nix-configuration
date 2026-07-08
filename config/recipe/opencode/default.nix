{
  agenix,
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
        context7Mcp = pkgs.writeShellScript "context7-mcp-authenticated" ''
          set -eu

          api_key_file=${config.age.secrets."context7-api-key".path}
          if [ ! -s "$api_key_file" ]; then
            echo "context7-mcp: missing Context7 API key at $api_key_file" >&2
            exit 1
          fi

          api_key="$(${pkgs.coreutils}/bin/cat "$api_key_file")"
          exec ${pkgs.lib.getExe pkgs.context7-mcp} --api-key "$api_key"
        '';
      in {
        imports = [(import ../../../lib/agenix/hm.nix {inherit agenix metadata;})];

        age.secrets = {
          context7-api-key.file = ./secrets/context7-api-key.age;
        };

        home.file.".config/opencode/AGENTS.md".source = ../../../files/AGENTS.md;

        home.shellAliases = {
          oc = "opencode";
        };

        programs.opencode = {
          enable = true;

          settings = {
            "$schema" = "https://opencode.ai/config.json";
            model = "openai/gpt-5.5";
            lsp = true;
            instructions = [
              "${config.home.homeDirectory}/.config/opencode/AGENTS.md"
            ];

            mcp = {
              context7 = {
                type = "local";
                command = [
                  "${context7Mcp}"
                ];
                enabled = true;
              };
            };

            permission = {
              read = "allow";
              glob = "allow";
              grep = "allow";
              list = "allow";
              edit = "allow";
              bash = {
                "*" = "ask";
                "jj diff*" = "allow";
                "jj evolog*" = "allow";
                "jj file list*" = "allow";
                "jj git remote list*" = "allow";
                "jj log*" = "allow";
                "jj operation log*" = "allow";
                "jj op log*" = "allow";
                "jj obslog*" = "allow";
                "jj root*" = "allow";
                "jj show*" = "allow";
                "jj status*" = "allow";
                "jj workspace list*" = "allow";
              };
              external_directory = "ask";
            };
          };

          tui = {
            theme = "gruvbox";
            attention = {
              enabled = true;
              notifications = true;
              sound = true;
            };
          };
        };
      }
    )
  ];
}
