_: {
  hm = [
    (_: {
      programs.fish = {
        interactiveShellInit = ''
          fish_vi_key_bindings
        '';
      };
    })
  ];
}
