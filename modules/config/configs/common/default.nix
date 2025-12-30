_: {
  common = {
    config =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          lolcat
        ];
      };
    hm =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ neofetch ];
      };
  };
}
