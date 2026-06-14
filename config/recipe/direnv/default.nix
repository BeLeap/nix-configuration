{
  direnv-overlay,
  direnv-instant,
}: {
  hm = [
    direnv-overlay.homeManagerModules.default
    direnv-instant.homeModules.direnv-instant
    (
      {pkgs, ...}: {
        programs = {
          direnv = {
            enable = true;
            package = pkgs.direnv;

            silent = true;

            mise.enable = true;
            config = {
              load_dotenv = true;
              warn_timeout = "1m";
            };
          };
          direnv-overlay.enable = true;
          direnv-instant = {
            enable = true;
            settings = {
              mux_delay = 1;
            };
          };
        };
      }
    )
  ];
}
