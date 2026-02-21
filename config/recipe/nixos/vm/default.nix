{
  lib,
  metadata,
}: (lib.optionalAttrs (metadata.distribution == "nixos" && lib.hasPrefix "vm-" metadata.name) {
  base = {modulesPath, ...}: {
    imports = [
      "${modulesPath}/virtualisation/qemu-vm.nix"
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # networking.useDHCP = false;
    # networking.interfaces.eth0.useDHCP = true;
    # FIXME: use automatically set dnses
    # temporary fix by using well-known dns
    networking.nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];

    services.getty.autologinUser = metadata.usernameLower;
    security.sudo.wheelNeedsPassword = false;

    virtualisation = {
      graphics = false;
      memorySize = 4096;
      cores = 4;
      diskSize = 128 * 1024;
      writableStoreUseTmpfs = false;
      useHostCerts = true;
      qemu.guestAgent.enable = true;
    };

    environment.systemPackages = [];

    system.stateVersion = "25.05";
  };
})
