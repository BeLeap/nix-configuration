{metadata, ...}: {
  base = {pkgs, ...}: {
    programs.fish = {
      enable = true;
      package = pkgs.unstable.fish;
    };

    users.users."${metadata.usernameLower}".shell = pkgs.unstable.fish;
  };
  hm = [
    ({pkgs, ...}: {
      programs.fish = {
        enable = true;
        package = pkgs.unstable.fish;
        interactiveShellInit = ''
          fish_vi_key_bindings
        '';

        plugins = [
          {
            name = "hydro";
            src = pkgs.fetchFromGitHub {
              owner = "jorgebucaran";
              repo = "hydro";
              rev = "f130b55ee3eaf099eccf588e2a62e5447068d120";
              hash = "sha256-Dfq974KpD1mtQKznIlkXfZfDnSF/4MfLTA18Ak0LADE=";
            };
          }
        ];
      };
    })
  ];
}
