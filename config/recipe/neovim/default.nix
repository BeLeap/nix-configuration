{inputs, ...}: {
  home = [
    (_: {imports = [inputs.nixvim.homeModules.nixvim];})
    ({
      inputs,
      pkgs,
      lib,
      ...
    }: let
      anyLsp = inputs.any-lsp.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in {
      home.packages = with pkgs; [
        # Telescope grep_string require ripgrep
        ripgrep
      ];
      programs.nixvim = {
        enable = true;
        enableMan = true;
        defaultEditor = true;

        colorschemes.gruvbox.enable = true;

        globals.mapleader = ",";

        editorconfig.enable = true;

        filetype = {
          extension = {
            jjdescription = "diff";
          };
        };

        opts = {
          number = true;
          relativenumber = true;

          expandtab = true;
          shiftwidth = 2;
          tabstop = 2;
          smartindent = true;

          ignorecase = true;
          smartcase = true;
          incsearch = true;

          splitright = true;
          splitbelow = true;

          clipboard = "unnamedplus";
          undofile = true;
          updatetime = 250;
          timeoutlen = 300;
          confirm = true;

          list = true;
          listchars = {
            tab = "» ";
            trail = "·";
          };

          completeopt = ["menu" "menuone" "noselect"];

          scrolloff = 999;
          foldlevelstart = 99;

          makeprg = "nix build";

          exrc = true;
        };

        keymaps = [
          {
            mode = "n";
            key = "<space>f";
            action = "<cmd>Telescope find_files<CR>";
          }
          {
            mode = "n";
            key = "<space>/";
            action = "<cmd>Telescope grep_string<CR>";
          }
          {
            mode = "n";
            key = "<leader>r";
            action = "<cmd>source ~/.config/nvim/init.lua<CR>";
          }
          {
            mode = "n";
            key = "<leader>f";
            action = "<cmd>lua vim.lsp.buf.format({ async = true })<CR>";
          }
        ];

        plugins = {
          telescope.enable = true;
          gitsigns.enable = true;
          oil.enable = true;
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
          treesitter = {
            enable = true;
            highlight.enable = true;
            indent.enable = true;
            folding.enable = true;
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
            {
              key = "K";
              lspBufAction = "hover";
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

        diagnostic.settings = {
          virtual_text = true;
          signs = true;
          underline = true;
          severity_sort = true;
          float = {
            border = "rounded";
            source = true;
          };
        };
      };
    })
  ];
}
