{ metadata, lib, ... }:
{
  homebrew = {
    enable = true;

    brews = [ ];
    casks = [ ] ++ (lib.optionals (metadata.kind == "personal") [ "logseq" ]);
  };
}
