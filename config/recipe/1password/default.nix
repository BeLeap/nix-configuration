_: {
  home = [
    (
      {pkgs, ...}: {
        home.packages = with pkgs; [
          _1password-cli
        ];
      }
    )
  ];

  darwin = {
    system = [
      (_: {
        homebrew.casks = ["1password"];
      })
    ];
  };

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
