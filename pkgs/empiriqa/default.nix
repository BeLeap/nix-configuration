{ pkgs, fetchFromGitHub }:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "empiriqa";
  version = "v0.1.0";
  src = fetchFromGitHub {
    owner = "ynqa";
    repo = "empiriqa";
    tag = version;
  };
  cargoLock.lockFile = ./Cargo.lock;
}
