{
  lib,
  metadata,
}: {
  base = [
    (lib.optionalAttrs (metadata.distribution == "nixos") (
      {pkgs, ...}: {
        hardware.graphics.enable = true;

        programs.hyprland = {
          enable = true;
          withUWSM = true;
          xwayland.enable = true;
        };

        services = {
          displayManager = {
            enable = metadata.gui;
            sddm = {
              enable = metadata.gui;

              wayland = {
                enable = true;
              };
            };
          };
        };

        i18n.inputMethod = {
          enable = metadata.gui;
          type = "kime";
          kime = {
            extraConfig = ''
              log:
                global_level: DEBUG
              engine:
                translation_layer: null
                default_category: Latin
                global_category_state: false
                global_hotkeys:
                  M-C-Backslash:
                    behavior: !Mode Math
                    result: ConsumeIfProcessed
                  Super-Space:
                    behavior: !Toggle
                    - Hangul
                    - Latin
                    result: Consume
                  M-C-E:
                    behavior: !Mode Emoji
                    result: ConsumeIfProcessed
                  Esc:
                    behavior: !Switch Latin
                    result: Bypass
                  Muhenkan:
                    behavior: !Toggle
                    - Hangul
                    - Latin
                    result: Consume
                  AltR:
                    behavior: !Toggle
                    - Hangul
                    - Latin
                    result: Consume
                  Hangul:
                    behavior: !Toggle
                    - Hangul
                    - Latin
                    result: Consume
                category_hotkeys:
                  Hangul:
                    ControlR:
                      behavior: !Mode Hanja
                      result: Consume
                    HangulHanja:
                      behavior: !Mode Hanja
                      result: Consume
                    F9:
                      behavior: !Mode Hanja
                      result: ConsumeIfProcessed
                mode_hotkeys:
                  Math:
                    Enter:
                      behavior: Commit
                      result: ConsumeIfProcessed
                    Tab:
                      behavior: Commit
                      result: ConsumeIfProcessed
                  Hanja:
                    Enter:
                      behavior: Commit
                      result: ConsumeIfProcessed
                    Tab:
                      behavior: Commit
                      result: ConsumeIfProcessed
                  Emoji:
                    Enter:
                      behavior: Commit
                      result: ConsumeIfProcessed
                    Tab:
                      behavior: Commit
                      result: ConsumeIfProcessed
                candidate_font: Noto Sans CJK KR
                xim_preedit_font:
                - Noto Sans CJK KR
                - 15.0
                latin:
                  layout: Colemak
                  preferred_direct: true
                hangul:
                  layout: sebeolsik-3-90
                  word_commit: false
                  preedit_johab: Needed
                  addons:
                    all:
                    - ComposeChoseongSsang
                    dubeolsik:
                    - TreatJongseongAsChoseong
                    sebeolsik-3-90:
                    - FlexibleComposeOrder
                    - ComposeChoseongSsang
                    - ComposeJongseongSsang
            '';
          };
        };

        environment.sessionVariables = {
          NIXOS_OZONE_WL = "1";
        };

        environment.systemPackages = [pkgs.wl-clipboard];
      }
    ))
  ];
}
