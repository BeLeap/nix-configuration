{ metadata, lib, ... }:
{
  homebrew = {
    enable = true;

    brews = [ ];
    casks = [
      "wezterm"
    ]
    ++ (lib.optionals (metadata.kind == "personal") [
      "logseq"
      "1password"
    ]);
  };
}
