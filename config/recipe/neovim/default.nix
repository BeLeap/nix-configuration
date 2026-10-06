{inputs, ...}: {
  home = [
    (_: {imports = [inputs.nixvim.homeModules.nixvim];})
    ({pkgs, ...}: {
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
        ];

        plugins = {
          telescope.enable = true;
          gitsigns.enable = true;
          oil.enable = true;
          treesitter = {
            enable = true;
            highlight.enable = true;
            indent.enable = true;
            folding.enable = true;
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
    ({
      pkgs,
      lib,
      ...
    }: {imports = [./lsp.nix];})
  ];
}
