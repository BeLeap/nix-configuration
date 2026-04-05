[
  {
    name = "beleap-m1air";
    kind = "personal";
    os = "darwin";
    arch = "aarch64";
    distribution = "macos";
    gui = true;
    recipes = [
      "default"
      "macos"
      "beleap-m1air"
      "personal"
      "onedrive"
    ];
  }
  {
    name = "beleap-macmini";
    kind = "personal";
    os = "darwin";
    arch = "aarch64";
    distribution = "macos";
    gui = true;
    recipes = [
      "default"
      "macos"
      "beleap-macmini"
      "personal"
      "onedrive"
    ];
  }
  {
    name = "csjang-m3pro";
    kind = "work";
    username = "cs.jang";
    email = "cs.jang@toss.im";
    os = "darwin";
    arch = "aarch64";
    distribution = "macos";
    gui = true;
    recipes = [
      "default"
      "macos"
    ];
  }
  {
    name = "vm-arm64-Darwin-personal";
    kind = "personal";
    os = "linux";
    arch = "aarch64";
    distribution = "nixos";
    gui = false;
    recipes = [
      "default"
      "vm"
      "nixos/vm"
      "personal"
    ];
  }
  {
    name = "vm-arm64-Darwin-work";
    kind = "work";
    username = "cs.jang";
    email = "cs.jang@toss.im";
    os = "linux";
    arch = "aarch64";
    distribution = "nixos";
    gui = false;
    recipes = [
      "default"
      "vm"
      "nixos/vm"
    ];
  }
]
