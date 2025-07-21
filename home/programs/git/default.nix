{ metadata, ... }:
{
  programs.git = {
    enable = true;

    userName = metadata.username;
    userEmail = metadata.email;
  };
}
