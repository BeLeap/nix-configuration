[
  {
    name = "beleap-m1air";
    kind = "personal";
    os = "darwin";
    arch = "aarch64";
    distribution = "macos";
    gui = true;
    recipes = ["macos/beleap-m1air"];
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
  }
  {
    name = "vm-arm64-Darwin-personal";
    kind = "personal";
    os = "linux";
    arch = "aarch64";
    distribution = "nixos";
    gui = false;
    recipes = [
      "vm"
      "nixos/vm"
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
      "vm"
      "nixos/vm"
    ];
  }
]
