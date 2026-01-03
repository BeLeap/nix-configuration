_: {
  hm =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        just
      ];
    };
}
