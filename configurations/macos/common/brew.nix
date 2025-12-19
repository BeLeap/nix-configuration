{ metadata, lib, ... }:
{
  homebrew = {
    enable = !(metadata.kind == "airgap");

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
    masApps =
      { }
      // (lib.optionalAttrs (metadata.kind == "personal") {
        KakaoTalk = 869223134;
      });
  };
}
