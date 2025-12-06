{ pkgs, metadata, ... }:
{
  nix.optimise.automatic = true;

  nixpkgs = {
    config.allowUnfree = true;
  };

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  programs.ssh = {
    enableDefaultConfig = false;
    knownHosts = {
      "github.com".publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
    };
  };

  # Necessary for using flakes on this system.
  nix.settings = {
    experimental-features = "nix-command flakes";
    min-free = "1M";
  };

  time.timeZone = "Asia/Seoul";

  environment.systemPackages = with pkgs; [
    vim
    curl
    git
  ];
}
// metadata.extraConfig
