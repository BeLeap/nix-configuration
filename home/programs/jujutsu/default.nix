{ metadata, ... }:
{
  programs.jujutsu = {
    enable = true;

    settings = {
      user = {
        email = metadata.email;
        name = metadata.username;
      };
      ui = {
        default-command = [
          "log"
          "--limit=10"
        ];
        paginate = "never";
      };
    };
  };
}
