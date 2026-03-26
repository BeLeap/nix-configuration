{
  lib,
  metadata,
  ...
}: {
  recipes =
    [
      "joplin"
    ]
    ++ (lib.optionals metadata.gui [
      "qbittorrent"
    ]);
}
