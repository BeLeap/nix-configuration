_: {
  hm = [
    ({pkgs, ...}: {
      programs.firefox = {
        enable = true;

        nativeMessagingHosts = with pkgs; [
          _1password-gui
        ];

        profiles = {
          "beleap" = {
            extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
              sidebery
              onepassword-password-manager
              wappalyzer
            ];
          };
        };
      };
    })
  ];
}
