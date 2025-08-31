{ rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "empiriqa";
  name = pname;
  version = "v0.1.0";
  src = fetchFromGitHub {
    owner = "ynqa";
    repo = "empiriqa";
    tag = version;
    hash = "sha256-TLjbhNUAykkKbChbVkm5pAC63RpmIxQjy5vFTom3XKQ=";
  };
  cargoHash = "sha256-Walh+rR42AGMEvWXNawXn0Mg97ctyw2goidBQZDR4s0=";
}
