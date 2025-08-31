{ metadata, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks =
      { }
      // (
        if (metadata.kind == "personal") then
          {
            "*" = {
              identityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
            };
          }
        else
          { }
      );
  };
}
