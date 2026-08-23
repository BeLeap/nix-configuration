_: {
  nixos = {
    system = [
      (_: {
        programs._1password-gui = {
          enable = true;
        };
      })
    ];
  };
}
