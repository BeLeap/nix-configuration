{ metadata, lib, ... }:
{
  homebrew = {
    enable = true;

    onActivation.cleanup = "uninstall";

    brews = [ ];
    casks = [
      "meetingbar"
    ]
    ++ (lib.optionals (metadata.kind == "personal") [
      "logseq"
      "1password"
    ]);
  };
}
