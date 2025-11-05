{
  inputs,
  ...
}:
{
  environment.systemPackages = [ ];

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  networking.knownNetworkServices = [
    "USB 10/100/1000 LAN"
    "USB 10/100/1000 LAN 2"
    "USB 10/100/1000 LAN 3"
    "USB 10/100/1000 LAN 4"
    "Thunderbolt Ethernet Slot 0"
    "Wi-Fi"
  ];
}
