[
  {
    name = "beleap-m1air";
    arch = "aarch64";
    backend = "darwin";
    recipes = [
      "default"
      "macos"
      "homebrew"
      "beleap-m1air"
      "personal"
      "discord"
      "onedrive"
      "kdeconnect-mac"
      "homerow"
      "pi-auto-model-personal"
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
      "beleap-macmini"
      "personal"
      "discord"
      "onedrive"
      "kdeconnect-mac"
      "pi-auto-model-personal"
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
      "work"
      "homerow"
      "pi-auto-model-work"
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
      "pi-auto-model-personal"
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
      "pi-auto-model-work"
    ];
  }
]
