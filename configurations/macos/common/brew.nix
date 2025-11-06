{ metadata, lib, ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
      extraFlags = [ "--verbose" ];
    };

    brews = [ ];
    casks = [
      "meetingbar"
      "karabiner-elements"
    ]
    ++ (lib.optionals (metadata.kind == "personal") [
      "logseq"
      "1password"
      "tailscale-app"
    ]);
  };
}
