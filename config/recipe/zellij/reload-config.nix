{pkgs}: let
  # Upstream WASI standard-library metadata requires the matching upstream Rust compiler.
  prebuiltRust = pkgs.rust_1_95.packages.prebuilt;
  wasmStd = pkgs.stdenvNoCC.mkDerivation {
    pname = "rust-std-wasm32-wasip1";
    version = prebuiltRust.rustc.version;
    src = pkgs.fetchurl {
      url = "https://static.rust-lang.org/dist/rust-std-${prebuiltRust.rustc.version}-wasm32-wasip1.tar.xz";
      hash = "sha256-huW22Yx1ILucOtT4y7vxS+ryMLDwa0N9s5jjxPfa5D4=";
    };
    nativeBuildInputs = [pkgs.xz];
    installPhase = ''
      ./install.sh --prefix="$out" --components=rust-std-wasm32-wasip1
    '';
  };
  wasmSysroot = pkgs.runCommand "rust-sysroot-wasm32-wasip1-${prebuiltRust.rustc.version}" {} ''
    mkdir -p "$out/lib/rustlib"
    for entry in ${prebuiltRust.rustc.unwrapped}/lib/rustlib/*; do
      ln -s "$entry" "$out/lib/rustlib/''${entry##*/}"
    done
    ln -s ${wasmStd}/lib/rustlib/wasm32-wasip1 "$out/lib/rustlib/wasm32-wasip1"
  '';
  wasmRustc = pkgs.wrapRustcWith {
    rustc-unwrapped = prebuiltRust.rustc.unwrapped;
    sysroot = wasmSysroot;
  };
  wasmRustPlatform = pkgs.makeRustPlatform {
    rustc = wasmRustc;
    inherit (prebuiltRust) cargo;
  };
in
  wasmRustPlatform.buildRustPackage {
    pname = "zellij-config-reloader";
    version = "0.1.0";
    src = ./reload-config;
    cargoLock.lockFile = ./reload-config/Cargo.lock;
    nativeBuildInputs = [pkgs.llvmPackages.lld];
    CARGO_TARGET_WASM32_WASIP1_LINKER = "${pkgs.llvmPackages.lld}/bin/wasm-ld";
    doCheck = false;
    dontCargoInstall = true;
    buildPhase = ''
      runHook preBuild
      cargo build --locked --offline --release --target wasm32-wasip1
      runHook postBuild
    '';
    installPhase = ''
      wasmFile=$(find target -type f -name '*.wasm' -print -quit)
      if [ -z "$wasmFile" ]; then
        echo "Rust build produced no WASM plugin artifact" >&2
        exit 1
      fi
      install -Dm444 "$wasmFile" "$out/share/zellij/plugins/config-reloader.wasm"
    '';
  }
