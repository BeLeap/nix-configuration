{metadata, ...}: {
  ageIdentityPaths = [
    (
      if metadata.os == "darwin"
      then "/Users/${metadata.usernameLower}/.age/key"
      else "/home/${metadata.usernameLower}/.age/key"
    )
  ];
}
