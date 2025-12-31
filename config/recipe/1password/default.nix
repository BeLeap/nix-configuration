{ lib, metadata }:
{
  base = [
    (lib.optionalAttrs (metadata.distribution == "macos" && metadata.kind == "personal") {
      homebrew = {
        casks = [ "1password" ];
      };
    })
  ];

  hm = (
    { ... }:
    {
      programs.ssh.matchBlocks = {
        "*" = {
          identityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
        };
      };
    }
  );
}
