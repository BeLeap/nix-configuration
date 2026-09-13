_: {
  home = [
    (
      {pkgs, ...}: {
        home.packages = with pkgs; [
          _1password-cli
        ];
      }
    )
  ];

  darwin = {
    system = [
      (_: {
        homebrew.casks = ["1password"];
      })
    ];
    home = [
      (_: {
        programs.ssh.settings."*".IdentityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
      })
    ];
  };

  nixos = {
    system = [
      (_: {
        programs._1password-gui = {
          enable = true;
        };
      })
    ];
    home = [
      (_: {
        programs.ssh.settings."*".IdentityAgent = "~/.1password/agent.sock";
      })
    ];
  };
}
