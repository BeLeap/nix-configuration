{
  inputs,
  pkgs,
  ...
}: let
  anyLsp = inputs.any-lsp.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  programs.nixvim = {
    files = {
      "plugin/enable-all-lsp.lua" = {
        extraConfigLua = ''
          local servers = vim.iter(vim.lsp.get_configs())
            :map(function(config)
              return config.name
            end)
            :totable()

          vim.lsp.enable(servers)
        '';
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>f";
        action = "<cmd>lua vim.lsp.buf.format({ async = true, filter = function(client) return client.name ~= 'nil_ls' end })<CR>";
      }
    ];
    plugins = {
      lsp.enable = true;
      fidget.enable = true;
      trouble.enable = true;
      blink-cmp = {
        enable = true;
        settings = {
          completion = {
            documentation.auto_show = true;
            accept.auto_brackets.enabled = true;
          };
        };
      };
      none-ls = {
        enable = true;
        sources = {
          code_actions = {
            statix.enable = true;
          };
          diagnostics = {
            codespell.enable = true;
            deadnix.enable = true;
            editorconfig_checker.enable = true;
            golangci_lint.enable = true;
            statix.enable = true;
          };
          formatting = {
            alejandra.enable = true;
            clang_format.enable = true;
            gofmt.enable = true;
            shfmt.enable = true;
          };
        };
      };
    };
    lsp = {
      completion.enable = true;
      documentColor.enable = true;
      inlayHints.enable = true;
      onTypeFormatting.enable = true;

      keymaps = [
        {
          key = "gd";
          action = "<cmd>Trouble lsp_definitions toggle focus=true<cr>";
        }
        {
          key = "gr";
          action = "<cmd>Trouble lsp_references toggle focus=true<cr>";
        }
        {
          key = "gt";
          action = "<cmd>Trouble lsp_type_definitions toggle focus=true<c>";
        }
        {
          key = "gi";
          action = "<cmd>Trouble lsp_implementations toggle focus=true<cr>";
        }
      ];

      servers = {
        nil_ls = {
          enable = true;
          config = {
            settings = {
              nil = {
                formatting = {
                  command.__raw = "vim.NIL";
                };
              };
            };
          };
        };
        lua_ls.enable = true;
        helm_ls.enable = true;
        yamlls.enable = true;
        "any-lsp" = {
          enable = true;
          package = anyLsp;
          config = {
            cmd = ["any-lsp"];
            root_markers = [
              [
                ".git"
                ".jj"
              ]
              "."
            ];
          };
        };
      };
    };
  };
}
