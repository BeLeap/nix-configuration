_: {
  nixos = {
    home = [
      (_: {
        programs.rofi = {
          enable = true;

          font = "Monoplex KR Nerd 14";
        };
      })
    ];
  };
}
