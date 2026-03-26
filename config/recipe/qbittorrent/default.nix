{pkgs, ...}: {
  hm = [
    {
      home.packages = [pkgs.qbittorrent];
    }
  ];
}
