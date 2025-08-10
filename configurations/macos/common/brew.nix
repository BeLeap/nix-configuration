{ metadata, lib, ... }:
{
  homebrew = {
    enable = true;

    brews = [ ];
    casks = [
      # nixpkgs darwin ghostty is broken
      # See https://github.com/ghostty-org/ghostty/discussions/4359
      "ghostty"
    ]
    ++ (lib.optionals (metadata.kind == "personal") [ "logseq" ]);
  };
}
