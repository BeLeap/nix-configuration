{
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation {
  name = "kotlin-ls";
  src = fetchzip {
    url = "https://download-cdn.jetbrains.com/kotlin-lsp/0.253.10629/kotlin-0.253.10629.zip";
    stripRoot = false;
    hash = "sha256-LCLGo3Q8/4TYI7z50UdXAbtPNgzFYtmUY/kzo2JCln0=";
  };

  installPhase = ''
    mkdir -p $out/bin

    sed -i 's/\/lib/\/..\/lib/' kotlin-lsp.sh

    mv kotlin-lsp.sh $out/bin/kotlin-ls
    chmod +x $out/bin/kotlin-ls
    mv lib $out/lib
    mv native $out/native
  '';

  checkPhase = ''
    kotlin-ls --help
  '';
}
