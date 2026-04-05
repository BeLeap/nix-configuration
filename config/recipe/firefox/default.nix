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
              "browser.aboutConfig.showWarning" = false;

              "browser.translations.automaticallyPopup" = false;

              "sidebar.verticalTabs" = true;
              "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;

              "app.update.auto" = false;
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
