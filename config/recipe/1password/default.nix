_: {
  hm = [
    (
      {pkgs, ...}: {
        home.packages = with pkgs; [
          _1password-cli
        ];
        programs.ssh.settings = {
          "*" = {
            IdentityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
          };
        };
      }
    )
  ];
}
