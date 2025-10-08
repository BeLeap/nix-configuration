{ rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "dnsi";
  name = pname;
  version = "v0.2.0";
  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "dnsi";
    tag = version;
    hash = "sha256-HWYn3IHUoH3248ZGCU9JKO3BALZqxiaNX1Q2+bHjw0A=";
  };
  cargoHash = "sha256-uIW7EDL2ulg6qDizjw5iHtc5HqyEZDBoXJxWHZOmoqo=";
}
