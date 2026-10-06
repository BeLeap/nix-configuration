{
  inputs,
  pkgs,
  lib,
  ...
}: let
  anyLsp = inputs.any-lsp.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "<leader>f";
        action = "<cmd>lua vim.lsp.buf.format({ async = true })<CR>";
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
                formatting = {command = ["${lib.getExe pkgs.alejandra}"];};
              };
            };
          };
        };
        lua_ls.enable = true;
        helm_ls.enable = true;
        yamlls.enable = true;
        basedpyright.enable = true;
        "any-lsp" = {
          enable = true;
          package = anyLsp;
          config = {
            cmd = ["any-lsp"];
            root_markers = [[".git" ".jj"] "."];
          };
        };
      };
    };
  };
}
