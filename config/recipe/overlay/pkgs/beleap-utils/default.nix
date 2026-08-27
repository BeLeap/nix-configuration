pkgs: let
  inherit (pkgs) lib;
in
  pkgs.symlinkJoin {
    name = "beleap-utils";
    paths = builtins.map (
      file:
        pkgs.writeShellScriptBin file (builtins.readFile (./. + "/scripts/${file}"))
    ) (builtins.attrNames (builtins.readDir ./scripts));

    nativeBuildInputs = [pkgs.makeWrapper];

    postBuild = ''
      for bin in $out/bin/*; do
        wrapProgram "$bin" --prefix PATH : ${lib.makeBinPath (with pkgs; [jq fd ax-cli])}
      done
    '';
  }
