{inputs, ...}: {
  home = [
    (_: {imports = [inputs.nixvim.homeModules.nixvim];})
    (_: {
      programs.nixvim = {
        enable = true;
        enableMan = true;

	colorschemes.gruvbox.enable = true;

	plugins = {
	  telescope.enable = true;
	};
      };
    })
  ];
}
