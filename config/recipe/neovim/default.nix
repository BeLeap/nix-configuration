{inputs, ...}: {
  home = [
    (_: {imports = [inputs.nixvim.homeModules.nixvim];})
    (_: {
      programs.nixvim = {
        enable = true;
        enableMan = true;

        colorschemes.gruvbox.enable = true;

        globals.mapleader = ",";

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
        };

        keymaps = [
          {
            mode = "n";
            key = "<space>f";
            action = "<cmd>Telescope find_files<CR>";
          }
          {
            mode = "n";
            key = "<leader>r";
            action = "<cmd>source ~/.config/nvim/init.lua<CR>";
          }
          {
            mode = "n";
            key = "<leader>f";
            action = "<cmd>source ~/.config/nvim/init.lua<CR>";
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
                accept.auto_brakets.enabled = true;
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
              lspBufAction = "definition";
            }
            {
              key = "gr";
              lspBufAction = "references";
            }
            {
              key = "gt";
              lspBufAction = "type_definition";
            }
            {
              key = "gi";
              lspBufAction = "implementation";
            }
            {
              key = "K";
              lspBufAction = "hover";
            }
          ];

          servers = {
            nil_ls.enable = true;
            lua_ls.enable = true;
            helm_ls.enable = true;
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
