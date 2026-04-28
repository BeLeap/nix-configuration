{metadata}: {
  hm = [
    ({pkgs, ...}: {
      programs.ghostty = {
        enable = true;
        package =
          if (metadata.os == "darwin")
          then pkgs.ghostty-bin
          else pkgs.ghostty;

        enableBashIntegration = true;
        enableZshIntegration = true;
        enableFishIntegration = true;

        settings = {
          theme = "Catppuccin Mocha";
        };
      };
    })
  ];
}
