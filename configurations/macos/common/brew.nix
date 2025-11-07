{ metadata, lib, ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
      extraFlags = [ "--verbose" ];
    };

    taps =
      [ ]
      ++ (lib.optionals (metadata.kind == "personal") [
        "imshuhao/kdeconnect"
      ]);
    brews = [ ];
    casks = [
      "meetingbar"
      "karabiner-elements"
    ]
    ++ (lib.optionals (metadata.kind == "personal") [
      "logseq"
      "1password"
      "tailscale-app"
      "imshuhao/kdeconnect/kdeconnect"
    ]);
  };
}
