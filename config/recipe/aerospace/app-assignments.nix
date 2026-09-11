{
  lib,
  scratchpad-exe,
}: let
  window-rule = {
    condition,
    run,
    check-further-callbacks ? false,
  }: {
    inherit check-further-callbacks run;
    "if" = condition;
  };
  app-window-rule = app-id: run:
    window-rule {
      condition = {inherit app-id;};
      inherit run;
    };
  floating-window-rule = condition:
    window-rule {
      check-further-callbacks = true;
      inherit condition;
      run = ["layout floating"];
    };

  scratchpad-apps = [
    {
      app-id = "com.1password.1password";
      app-name = "1Password";
    }
  ];
  scratchpad-window-rules =
    lib.map (
      app:
        app-window-rule app.app-id [
          "layout floating"
          "exec-and-forget ${scratchpad-exe} move --all-matching ${lib.escapeShellArg app.app-name}"
        ]
    )
    scratchpad-apps;

  workspace-apps = [
    {
      app-id = "com.github.wez.wezterm";
      workspace = "1";
    }
    {
      app-id = "com.apple.Safari";
      workspace = "2";
    }
    {
      app-id = "org.nixos.firefox";
      workspace = "2";
    }
    {
      app-id = "com.google.Chrome";
      workspace = "3";
    }
    {
      app-id = "net.cozic.joplin-desktop";
      workspace = "3";
    }
    {
      app-id = "notion.id";
      workspace = "3";
    }
    {
      app-id = "com.tinyspeck.slackmacgap";
      workspace = "10";
    }
    {
      app-id = "com.hnc.Discord";
      workspace = "10";
    }
  ];
  workspace-window-rules =
    lib.map (
      app: app-window-rule app.app-id ["move-node-to-workspace ${app.workspace}"]
    )
    workspace-apps;

  floating-window-rules = [
    (floating-window-rule {
      window-title-regex-substring = "Picture-in-Picture|화면 속 화면";
    })
    (floating-window-rule {app-id = "com.kakao.KakaoTalkMac";})
  ];
  one-password-window-rule = window-rule {
    condition = {
      window-title-regex-substring = "1Password";
    };
    run = ["layout floating"];
  };
  default-window-rule = window-rule {
    condition = {
      app-name-regex-substring = ".*";
    };
    run = ["move-node-to-workspace 9"];
  };

  on-window-detected =
    scratchpad-window-rules
    ++ floating-window-rules
    ++ workspace-window-rules
    ++ [
      one-password-window-rule
      default-window-rule
    ];
in {
  inherit on-window-detected scratchpad-apps;
}
