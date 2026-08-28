_: {
  nixos = {
    home = [
      (_: {
        programs.rofi = {
          enable = true;

          font = "Hanadia Mono 14";
        };
      })
    ];
  };
}
