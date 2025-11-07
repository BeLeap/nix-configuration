_: {
  programs.direnv = {
    enable = true;

    enableZshIntegration = true;
    enableBashIntegration = true;

    config = {
      load_dotenv = true;
      warn_timeout = "1m";
    };
  };
}
