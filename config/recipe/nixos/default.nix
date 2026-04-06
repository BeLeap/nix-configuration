{
  lib,
  metadata,
}: (lib.optionalAttrs (metadata.distribution == "nixos") {
  base = _: {
    security.polkit.enable = true;

    users.groups.beleap = {};
    users.users."${metadata.usernameLower}" = {
      isNormalUser = true;
      home = "/home/${metadata.usernameLower}";
      group = "beleap";
      extraGroups = ["wheel"];
    };
  };
})
