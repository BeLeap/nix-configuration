{
  metadata,
  pkgs,
  lib,
  ...
}:
{
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  hardware.graphics.enable = metadata.gui;

  security.polkit.enable = true;

  users.users."${metadata.usernameLower}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNrBVLG52+DGp9mHdt5H45alxWVCLu5JsodOPryPar5R620vqryWONGsE9FI8EeFRiBvIvNhhvYlbTzaSYU46koVRAUcjFUH3Wd3NW15sY4UiC9RYVMMtc0IpghSTa0cPH06XvU0d8cftySfarsT6rlJPLDpOKKn0yrbfI3ErncLpIWyBIYELkzJ3azeb4J8L2KoO+l4Ce4QR7E1eyqRXOPT81ZwK19mTW/F+H+UAlcQrv5uUh3NZclmahE3Vwc23VWORwmBvHnhcZSOb/M79lk45WVUFZYPBqSPxihNd9Cpcq7TgKczS1liiO2S2NIJ73wG/UviuR52fOqBagJBlL"
    ];
  };

  programs.hyprland = {
    enable = metadata.gui;
    withUWSM = true;
    xwayland.enable = true;
  };

  services = {
    displayManager = {
      enable = metadata.gui;
      sddm = {
        enable = true;

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

  environment.systemPackages =
    [ ]
    ++ (lib.optionals (metadata.gui) (
      with pkgs;
      [
        wl-clipboard
      ]
    ));
}
