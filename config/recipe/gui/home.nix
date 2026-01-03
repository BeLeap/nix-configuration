{
  metadata,
  lib,
  ...
}:
{
  imports =
    [ ]
    ++ lib.optionals metadata.gui (
      map (p: (./. + "/programs/${p}")) [
        "firefox"
        "wezterm"
      ]
    );
}
