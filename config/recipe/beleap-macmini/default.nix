_: {
  includes = [
    "ollama"
    "zeroclaw"
  ];

  darwin = {
    system = [
      (_: {
        homebrew.brews = ["googleworkspace-cli"];
      })
      (_: {
        services.github-runners."beleap-macmini" = {
          enable = true;
          url = "https://github.com/BeLeap/nix-configuration";
          tokenFile = "/run/secrets/github-runner.token";
          extraLabels = ["beleap-macmini"];
          ephemeral = false;
        };
      })
    ];

    home = [
      ({pkgs, ...}: {
        home.packages = [pkgs.isync];
      })
      (_: {
        beleap.services.zeroclaw = {
          enable = true;
          model = "qwen3.5:4b";
          discordUserId = "540435382853173280";
        };
      })
    ];
  };
}
