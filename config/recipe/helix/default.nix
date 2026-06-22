_: {
  hm = [
    (
      {
        pkgs,
        lib,
        ...
      }: {
        programs.helix = {
          enable = true;
          package = pkgs.unstable.helix;

          defaultEditor = true;

          settings = {
            theme = "nord";

            editor = import ./editor.nix;
          };

          languages = {
            language-server = import ./language-servers.nix {inherit pkgs lib;};
            language = import ./languages.nix {inherit pkgs lib;};
          };
        };
      }
    )
  ];
}
