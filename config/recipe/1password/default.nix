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
}
