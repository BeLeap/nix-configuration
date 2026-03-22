_: {
  hm = [
    ({
      pkgs,
      config,
      ...
    }: {
      home = {
        packages = with pkgs; [
          nodejs
        ];

        file.".npmrc" = {
          text = ''
            prefix = "${config.home.homeDirectory}/.npm-global";
          '';
        };

        sessionPath = [
          "${config.home.homeDirectory}/.npm-global"
        ];
      };
    })
  ];
}
