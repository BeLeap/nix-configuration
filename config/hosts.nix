[
  {
    name = "beleap-m1air";
    arch = "aarch64";
    backend = "darwin";
    recipes = [
      "default"
      "macos"
      "macos/homebrew"
      "macos/personal"
      "beleap-m1air"
      "personal"
      "onedrive"
      "1password"
      "kdeconnect-mac"
    ];
  }
  {
    name = "beleap-macmini";
    arch = "aarch64";
    backend = "darwin";
    recipes = [
      "default"
      "macos"
      "macos/homebrew"
      "macos/personal"
      "beleap-macmini"
      "personal"
      "onedrive"
      "1password"
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
      "macos/homebrew"
      "macos/work"
      "work"
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
      "1password"
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
