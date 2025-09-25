{ metadata, lib, ... }:
{
  homebrew = {
    enable = true;

    brews = [ ];
    casks = [
      "wezterm"
      "meetingbar"
    ]
    ++ (lib.optionals (metadata.kind == "personal") [
      "logseq"
      "1password"
      "discord"
    ]);
  };
}
