_: {
  hm = [
    ({pkgs, ...}: {
      home = {
        packages = with pkgs; [
          nodejs
        ];

        file.".npmrc" = {
          text = ''
            prefix = "~/.npm-global";
          '';
        };

        sessionPath = [
          "~/.npm-global"
        ];
      };
    })
  ];
}
