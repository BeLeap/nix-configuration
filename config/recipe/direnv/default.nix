_: {
  hm = [
    (
      _:
      {
  programs.direnv = {
    enable = true;

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
