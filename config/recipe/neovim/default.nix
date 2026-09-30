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
	];

	plugins = {
	  telescope.enable = true;
	  gitgutter.enable = true;
	};
      };
    })
  ];
}
