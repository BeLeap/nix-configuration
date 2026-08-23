_: {
  includes = [
    "joplin"
    "syncthing"
    "keepassxc"
  ];
  home = [
    ({pkgs, ...}: {
      programs.firefox.profiles."beleap".extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        joplin-web-clipper
        keepassxc-browser
      ];
    })
  ];
}
