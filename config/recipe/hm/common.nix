{
  metadata,
  config,
  ...
}: {
  programs.home-manager.enable = true;
  home = {
    stateVersion = "25.05";

    sessionVariables = {
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
    };

    username = metadata.usernameLower;

    file = {
      "dl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Downloads";
    };
  };
}
