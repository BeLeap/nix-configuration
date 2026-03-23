{lib}: {
  base = _: {
    networking.knownNetworkServices = [
      "USB 10/100/1000 LAN"
      "USB 10/100/1000 LAN 2"
      "USB 10/100/1000 LAN 3"
      "USB 10/100/1000 LAN 4"
      "Thunderbolt Ethernet Slot 0"
      "Wi-Fi"
    ];
  };
  hm = [
    ({pkgs, ...}: {
      home.packages = with pkgs; [realvnc-vnc-viewer];
    })
  ];
}
