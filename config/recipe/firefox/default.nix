_: {
  hm = [
    ({pkgs, ...}: {
      programs.firefox = {
        enable = true;

        nativeMessagingHosts = with pkgs; [
          _1password-gui
        ];

        policies = {
          DontCheckDefaultBrowser = true;
          DisableFirefoxStudies = true;
          DisableTelemetry = true;
          DisableFirefoxAccounts = false;
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;
          OfferToSaveLoginsDefault = false;
          PasswordManagerEnabled = true;
          FirefoxHome = {
            Search = true;
            Pocket = false;
            Snippets = false;
            TopSites = false;
            Highlights = false;
          };
          UserMessaging = {
            ExtensionRecommendations = false;
            SkipOnboarding = true;
          };
        };

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
              consent-o-matic
              joplin-web-clipper
            ];
          };
        };
      };
    })
  ];
}
