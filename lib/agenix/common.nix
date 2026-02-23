{metadata, ...}: {
  ageIdentityPaths = [
    (
      if metadata.os == "darwin"
      then "/Users/${metadata.usernameLower}/.ssh/id_ed25519"
      else "/home/${metadata.usernameLower}/.ssh/id_ed25519"
    )
  ];
}
