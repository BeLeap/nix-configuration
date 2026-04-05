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
            settings = {
              "sidebar.verticalTabs" = true;
              "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
            };
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
