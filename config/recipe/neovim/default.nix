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

	  scrolloff = 999;
	};

	keymaps = [
	  { mode = "n"; key = "<space>f"; action = "<cmd>Telescope find_files<CR>"; }
	  { mode = "n"; key = "<leader>r"; action = "<cmd>source ~/.config/nvim/init.lua<CR>"; }
	];

	plugins = {
	  telescope.enable = true;
	  gitsigns.enable = true;
	  lsp.enable = true;
	};

	lsp = {
	  completion.enable = true;
	  documentColor.enable = true;
	  inlayHints.enable = true;

	  keymaps = [
	    {key="gd"; lspBufAction="definition";}
	    {key="gr"; lspBufAction="references";}
	    {key="gt"; lspBufAction="type_definition";}
	    {key="gi"; lspBufAction="implementation";}
	    {key="K"; lspBufAction="hover";}
	  ];

	  servers = {
	    nil_ls.enable = true;
	    lua_ls.enable = true;
	  };
	};
      };
    })
  ];
}
