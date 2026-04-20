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
      };
    })
  ];
}
