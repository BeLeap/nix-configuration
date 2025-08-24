{ metadata, ... }:
{
  programs.jujutsu = {
    enable = true;

    settings = {
      user = {
        email = metadata.email;
        name = metadata.username;
      };
    };
  };
}
