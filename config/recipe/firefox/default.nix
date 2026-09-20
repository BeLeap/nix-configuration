_: {
  home = [
    ({
      config,
      pkgs,
      ...
    }: let
      firefoxConfigPath = "Library/Application Support/org.nixos.firefox";
      wrappedFirefox = pkgs.firefox.override {
        appDataDir = "${config.home.homeDirectory}/${firefoxConfigPath}";
      };
      firefoxPackage =
        if pkgs.stdenv.hostPlatform.isDarwin
        then
          wrappedFirefox.overrideAttrs (oldAttrs: {
            # LaunchServices and AeroSpace need the real process at the
            # executable path declared by Info.plist. Nixpkgs' shell wrapper
            # otherwise leaves Firefox running as `.firefox-old`.
            buildCommand =
              oldAttrs.buildCommand
              + ''
                app="$out/Applications/Firefox.app"
                executable="$app/Contents/MacOS/firefox"
                realExecutable="$app/Contents/MacOS/.firefox-old"
                plist="$app/Contents/Info.plist"

                if [ ! -x "$executable" ] || [ ! -x "$realExecutable" ]; then
                  echo "unexpected Nixpkgs Firefox wrapper layout" >&2
                  exit 1
                fi

                mv "$executable" "$app/Contents/MacOS/firefox-wrapper"
                mv "$realExecutable" "$executable"

                cp -L "$plist" "$plist.tmp"
                chmod u+w "$plist.tmp"
                /usr/bin/plutil -replace "LSEnvironment.MOZ_APP_DATA" -string "${config.home.homeDirectory}/${firefoxConfigPath}" "$plist.tmp"
                /usr/bin/plutil -replace "LSEnvironment.MOZ_APP_LAUNCHER" -string "firefox" "$plist.tmp"
                /usr/bin/plutil -replace "LSEnvironment.MOZ_LEGACY_PROFILES" -string "1" "$plist.tmp"
                /usr/bin/plutil -replace "LSEnvironment.MOZ_ALLOW_DOWNGRADE" -string "1" "$plist.tmp"
                /usr/bin/plutil -replace "LSEnvironment.MOZ_SYSTEM_DIR" -string "$out/lib/mozilla" "$plist.tmp"
                /usr/bin/plutil -replace "LSEnvironment.LD_LIBRARY_PATH" -string "${wrappedFirefox.libs}" "$plist.tmp"
                rm "$plist"
                mv "$plist.tmp" "$plist"
              '';
          })
        else wrappedFirefox;
    in {
      programs.firefox = {
        enable = true;
        package = firefoxPackage;
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
