_: {
  darwin = {
    home = [
      (
        {
          inputs,
          lib,
          pkgs,
          ...
        }: let
          aerospace = pkgs.unstable.aerospace;
          aerospace-exe = lib.getExe aerospace;
          jq-exe = lib.getExe pkgs.jq;

          scratchpad = inputs.aerospace-scratchpad.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (_: {
            # v0.6.0 shipped with a stale source hash in its Nix expression.
            src = pkgs.fetchFromGitHub {
              owner = "cristianoliveira";
              repo = "aerospace-scratchpad";
              rev = "v0.6.0";
              hash = "sha256-BOy4wTvqWCgNxqKybLAl3iVe0T+P9Y9JcbupXb3KhyM=";
            };
            vendorHash = "sha256-jYCA3DNoi9Mj55t6ru76voENM8VSJt7Gp74JV7Vq19k=";
          });
          scratchpad-exe = lib.getExe' scratchpad "aerospace-scratchpad";

          app-assignments = import ./app-assignments.nix {
            inherit lib scratchpad-exe;
          };
          inherit (app-assignments) scratchpad-apps;
          scripts = import ./scripts.nix {
            inherit aerospace-exe jq-exe lib pkgs scratchpad-exe;
            inherit scratchpad-apps;
          };
          inherit (scripts) scratchpad-toggle workspace-change-handler;
          keybindings = import ./keybindings.nix {
            inherit lib;
            click-notification = "${pkgs.beleap-utils}/bin/click-notification";
            inherit scratchpad-toggle;
          };
        in {
          home.packages = [scratchpad];

          programs.aerospace = {
            enable = true;
            package = aerospace;

            launchd = {
              enable = true;
              keepAlive = true;
            };

            settings = {
              default-root-container-layout = "tiles";

              key-mapping = {
                preset = "colemak";
              };

              exec-on-workspace-change = [
                "${workspace-change-handler}"
              ];

              mode.main.binding = keybindings;
              inherit (app-assignments) on-window-detected;
            };
          };
        }
      )
    ];
  };
}
