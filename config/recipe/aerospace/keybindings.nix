{
  click-notification,
  lib,
  scratchpad-toggle,
}: let
  workspace-bindings = lib.mergeAttrsList (
    lib.map (
      workspace: let
        workspace-name = toString workspace;
      in {
        "alt-${workspace-name}" = "workspace ${workspace-name}";
        "alt-shift-${workspace-name}" = "move-node-to-workspace ${workspace-name}";
      }
    )
    (lib.range 1 9)
  );
in
  {
    alt-0 = "workspace 10";
    alt-shift-s = "exec-and-forget ${scratchpad-toggle}";
    alt-h = "focus left";
    alt-j = "focus down";
    alt-k = "focus up";
    alt-l = "focus right";

    alt-f = "layout floating";
    alt-t = "layout tiling";
    cmd-n = "exec-and-forget ${click-notification}";
  }
  // workspace-bindings
