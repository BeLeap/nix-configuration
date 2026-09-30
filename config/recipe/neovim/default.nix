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
	};

	plugins = {
	  telescope.enable = true;
	  gitgutter.enable = true;
	};
      };
    })
  ];
}
