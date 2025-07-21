{ metadata, ... }:
{
  programs.git = {
    enable = true;

    userName = metadata.username;
    userEmail = metadata.email;

    ignores = [
      "root.mark"
      ".tool-versions"
      ".envrc"
      ".helix"
      "CLAUDE.md"
    ];
  };
}
