_: {
  base = _: {
    programs._1password-gui = {
      enable = true;
    };
  };
  hm = [
    (
      {pkgs, ...}: {
        home.packages = with pkgs; [
          _1password-cli
        ];
        programs.ssh.matchBlocks = {
          "*" = {
            identityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
          };
        };
      }
    )
  ];
}
