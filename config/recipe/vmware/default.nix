{host, ...}: {
  nixos.system = [
    (_: {
      boot = {
        initrd.availableKernelModules = [
          "ahci"
          "nvme"
          "sr_mod"
          "uhci_hcd"
          "usbhid"
          "xhci_pci"
        ];

        loader = {
          systemd-boot = {
            enable = true;
            consoleMode = "0";
          };
          efi.canTouchEfiVariables = true;
        };
      };

      fileSystems."/" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "ext4";
      };
      fileSystems."/boot" = {
        device = "/dev/disk/by-label/BOOT";
        fsType = "vfat";
      };

      networking.interfaces.enp2s0.useDHCP = true;
      networking.resolvconf.dnsExtensionMechanism = false;
      security.sudo.wheelNeedsPassword = false;
      services.getty.autologinUser = host.usernameLower;
      services.openssh.enable = true;
      system.stateVersion = "25.05";
      virtualisation.vmware.guest.enable = true;
    })
  ];
}
