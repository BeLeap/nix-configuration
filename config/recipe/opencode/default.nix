{
  agenix,
  metadata,
  ...
}: {
  hm = [
    (
      {
        config,
        lib,
        ...
      }: {
        imports = [(import ../../../lib/agenix/hm.nix {inherit agenix metadata;})];

        age.secrets = {
          context7-api-key.file = ./secrets/context7-api-key.age;
        };

        home.file.".config/opencode/AGENTS.md".source = ../../../files/AGENTS.md;

        home.shellAliases = {
          oc = "opencode";
        };

        programs.zsh.initContent = lib.mkAfter ''
          if [ -f ${config.age.secrets."context7-api-key".path} ]; then
            export CONTEXT7_API_KEY="$(cat ${config.age.secrets."context7-api-key".path})"
          fi
        '';

        programs.opencode = {
          enable = true;

          settings = {
            "$schema" = "https://opencode.ai/config.json";
            model = "openai/gpt-5.5";
            instructions = [
              "${config.home.homeDirectory}/.config/opencode/AGENTS.md"
            ];

            mcp = {
              context7 = {
                type = "remote";
                url = "https://mcp.context7.com/mcp";
                enabled = true;
                headers = {
                  Authorization = "Bearer \${CONTEXT7_API_KEY}";
                };
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
          };
        };
      }
    )
  ];
}
