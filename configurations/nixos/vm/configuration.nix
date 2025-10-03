{
  pkgs,
  modulesPath,
  nixpkgs,
  ...
}:
{
  imports = [
    "${modulesPath}/virtualisation/qemu-vm.nix"
  ];

  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;

  services.getty.autologinUser = "beleap";

  virtualisation.graphics = false;
  virtualisation.host.pkgs = nixpkgs.legacyPackages.aarch64-darwin;

  environment.systemPackages = with pkgs; [
    cowsay
    lolcat
  ];

  system.stateVersion = "25.05";
}
