{direnv-overlay}: {
  hm = [
    direnv-overlay.homeManagerModules.default
    (
      {pkgs, ...}: {
        programs.direnv = {
          enable = true;
          package = pkgs.direnv;

          enableZshIntegration = true;
          enableBashIntegration = true;

          silent = true;
          config = {
            load_dotenv = true;
            warn_timeout = "1m";
          };
        };
        programs.direnv-overlay = {
          enable = true;
        };
      }
    )
  ];
}
