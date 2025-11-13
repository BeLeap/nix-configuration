{
  stdenv,
  fetchurl,
  pkgs,
}:
stdenv.mkDerivation rec {
  pname = "kdeconnect";
  name = pname;
  version = "5498";

  src = fetchurl {
    url = "https://origin.cdn.kde.org/ci-builds/network/kdeconnect-kde/master/macos-arm64/kdeconnect-kde-master-5498-macos-clang-arm64.dmg";
    hash = "sha256-GOC4hyk9peYuA7GfKrq3ls8ZKQmFcBIWaTCPoN80vdM=";
  };

  nativeBuildInputs = [ pkgs.undmg ];

  sourceRoot = ".";

  unpackPhase = ''
    runHook preUnpack
    undmg "$src"
    # (선택) 무슨 .app이 나왔는지 로그
    echo "Apps: " *.app || true
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    # DMG 안의 모든 .app을 복사 (하나만 있으면 하나만 복사됨)
    cp -R *.app $out/Applications/
    runHook postInstall
  '';

  meta.platforms = [
    "aarch64-darwin"
  ];
}
