{
  inputs,
  host,
  ...
}: {
  nixos = {
    system = [
      (_: {
        virtualisation.host.pkgs = import inputs.nixpkgs {system = "aarch64-darwin";};
        boot.binfmt.emulatedSystems = [
          "x86_64-linux"
        ];
        virtualisation.sharedDirectories = {
          defaultShared = {
            source = "/Users/${host.usernameLower}/shared";
            target = "/home/${host.usernameLower}/shared";
          };
        };
      })
      ({modulesPath, ...}: {
        imports = [
          "${modulesPath}/virtualisation/qemu-vm.nix"
        ];

        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        # Use the DNS servers provided by DHCP instead of pinning public resolvers.

        services.getty.autologinUser = host.usernameLower;
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
      })
    ];
  };
}
