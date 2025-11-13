{ metadata, lib, ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
      extraFlags = [ "--verbose" ];
    };

    taps = [ ];
    brews = [ ];
    casks = [
      "meetingbar"
      "karabiner-elements"
      "wireshark-chmodbpf"
    ]
    ++ (lib.optionals (metadata.kind == "personal") [
      "logseq"
      "1password"
      "tailscale-app"
    ]);
  };
}
