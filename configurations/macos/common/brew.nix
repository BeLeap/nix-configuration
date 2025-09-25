{ metadata, lib, ... }:
{
  homebrew = {
    enable = true;

    brews = [ ];
    casks = [
      "meetingbar"
    ]
    ++ (lib.optionals (metadata.kind == "personal") [
      "logseq"
      "1password"
      "discord"
    ]);
  };
}
