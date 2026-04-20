_: {
  hm = [
    ({pkgs, ...}: {
      programs.firefox = {
        enable = true;

        policies = {
          DontCheckDefaultBrowser = true;
          DisableFirefoxStudies = true;
          DisableTelemetry = true;
          DisableFirefoxAccounts = false;
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;
          OfferToSaveLoginsDefault = false;
          PasswordManagerEnabled = false;
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
            search = {
              default = "ddg";
              engines = {
                ddg = {
                  name = "DuckDuckGo";
                  urls = [{template = "https://duckduckgo.com/?q={searchTerms}";}];
                  icon = "https://duckduckgo.com/favicon.ico";
                  updateInterval = 24 * 60 * 60 * 1000;
                };
              };
            };
            settings = {
              "browser.aboutConfig.showWarning" = false;

              "browser.translations.automaticallyPopup" = false;

              "sidebar.verticalTabs" = true;
              "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;

              "app.update.auto" = false;

              "signon.rememberSignons" = false;
              "signon.autofillForms" = false;
              "signon.generation.enabled" = false;
              "signon.management.page.breach-alerts.enabled" = false;
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
