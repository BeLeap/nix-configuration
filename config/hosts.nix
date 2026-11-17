[
  {
    name = "beleap-m1air";
    arch = "aarch64";
    backend = "darwin";
    recipes = [
      "default"
      "macos"
      "homebrew"
      "workstation"
      "beleap-m1air"
      "personal"
      "discord"
      "onedrive"
      "kdeconnect-mac"
      "homerow"
    ];
  }
  {
    name = "beleap-macmini";
    arch = "aarch64";
    backend = "darwin";
    recipes = [
      "default"
      "macos"
      "homebrew"
      "workstation"
      "beleap-macmini"
      "personal"
      "discord"
      "onedrive"
      "kdeconnect-mac"
    ];
  }
  {
    name = "csjang-m3pro";
    username = "cs.jang";
    email = "cs.jang@toss.im";
    arch = "aarch64";
    backend = "darwin";
    recipes = [
      "default"
      "macos"
      "homebrew"
      "workstation"
      "work"
      "homerow"
    ];
  }
  {
    name = "vm-arm64-Darwin-personal";
    arch = "aarch64";
    backend = "nixos";
    recipes = [
      "default"
      "nixos"
      "vm"
      "personal"
    ];
  }
  {
    name = "vm-arm64-Darwin-work";
    username = "cs.jang";
    email = "cs.jang@toss.im";
    arch = "aarch64";
    backend = "nixos";
    recipes = [
      "default"
      "nixos"
      "vm"
      "work"
    ];
  }
]
