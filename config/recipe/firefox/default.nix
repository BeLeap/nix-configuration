_: {
  home = [
    ({config, pkgs, ...}: let
      firefoxConfigPath = "Library/Application Support/org.nixos.firefox";
    in {
      programs.firefox = {
        enable = true;
        # Keep Nixpkgs Firefox data outside macOS's Mozilla-owned app-data path.
        package = pkgs.firefox.override {
          appDataDir = "${config.home.homeDirectory}/${firefoxConfigPath}";
        };
        configPath = firefoxConfigPath;

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
              force = true;
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
              wappalyzer
              consent-o-matic
              wayback-machine
              pkgs.saml-tracer
            ];
          };
        };
      };
    })
  ];
}
