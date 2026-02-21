{
  lib,
  metadata,
}: (lib.optionalAttrs (metadata.name == "beleap-m1air") {
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
})
