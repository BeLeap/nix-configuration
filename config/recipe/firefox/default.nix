_: {
  hm = [
    ({pkgs, ...}: {
      programs.firefox = {
        enable = true;

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
