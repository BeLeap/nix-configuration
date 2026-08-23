_: {
  nixos = {
    home = [
      (_: {
        programs.rofi = {
          enable = true;

          font = "CaskaydiaCove Nerd Font 14";
        };
      })
    ];
  };
}
