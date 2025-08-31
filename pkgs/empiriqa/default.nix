{ rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "empiriqa";
  name = pname;
  version = "v0.1.0";
  src = fetchFromGitHub {
    owner = "ynqa";
    repo = "empiriqa";
    tag = version;
  };
  cargoLock.lockFile = ./Cargo.lock;
}
