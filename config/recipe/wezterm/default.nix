_: {
  hm = [
    ({
      lib,
      pkgs,
      ...
    }: let
      weztermDmg = pkgs.stdenv.mkDerivation {
        pname = "wezterm";
        version = "20240203-110809-5046fc22";

        src = pkgs.fetchurl {
          url = "https://github.com/wezterm/wezterm/releases/download/20240203-110809-5046fc22/WezTerm-macos-20240203-110809-5046fc22.zip";
          hash = "sha256-53OIytVfLp2pWiIKiSBqbFj4ZYdKYpt8PqPBYvVpIiQ=";
        };
        sourceRoot = ".";

        nativeBuildInputs = [pkgs.unzip];

        unpackPhase = ''
          runHook preUnpack
          unzip "$src"
          runHook postUnpack
        '';

        installPhase = ''
          runHook preInstall
          mkdir -p $out/Applications
          mkdir -p $out/bin
          # DMG 안의 모든 .app을 복사 (하나만 있으면 하나만 복사됨)
          cp -R WezTerm-macos-20240203-110809-5046fc22/WezTerm.app $out/Applications/
          for bin in wezterm wezterm-gui wezterm-mux-server; do
            ln -s $out/Applications/WezTerm.app/Contents/MacOS/$bin $out/bin/$bin
          done
          runHook postInstall
        '';

        meta.platforms = [
          "aarch64-darwin"
        ];
      };
      weztermConfig = pkgs.writeText "wezterm.lua" (
        builtins.replaceStrings ["@zsh@"] ["${lib.getExe pkgs.zsh}"] (builtins.readFile ./wezterm.lua)
      );
    in {
      home.packages = [
        (
          if pkgs.stdenv.isDarwin
          then weztermDmg
          else pkgs.wezterm
        )
      ];

      xdg.configFile."wezterm/wezterm.lua".source = weztermConfig;
    })
  ];
}
