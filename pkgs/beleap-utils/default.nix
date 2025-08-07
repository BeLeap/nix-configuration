pkgs:

pkgs.symlinkJoin {
  name = "beleap-utils";
  paths = [
    (pkgs.writeShellScriptBin "crcpr" (builtins.readFile ./crcpr))
    (pkgs.writeShellScriptBin "fco" (builtins.readFile ./fco))
    (pkgs.writeShellScriptBin "fcd" (builtins.readFile ./fcd))
  ];
}
