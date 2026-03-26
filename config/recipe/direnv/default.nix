_: {
  hm = [
    (
      {pkgs, ...}: {
        programs.direnv = {
          enable = true;
          package = pkgs.unstable.direnv;

          enableZshIntegration = true;
          enableBashIntegration = true;

          silent = true;
          config = {
            load_dotenv = true;
            warn_timeout = "1m";
          };
        };
      }
    )
  ];
}
