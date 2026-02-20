_: {
  hm = [
    (
      { metadata, ... }:
      {
  programs.nh = {
    enable = true;
    flake =
      (if (metadata.os == "darwin") then "/Users" else "/home")
      + "/"
      + metadata.usernameLower
      + "/nix-configuration#"
      + (if (metadata.os == "darwin") then "darwinConfigurations" else "nixosConfigurations ")
      + "."
      + metadata.name;

    clean = {
      enable = true;
    };
  };
}
    )
  ];
}
