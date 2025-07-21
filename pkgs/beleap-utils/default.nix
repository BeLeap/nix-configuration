pkgs:

pkgs.symlinkJoin {
  name = "beleap-utils";
  paths = [
    (pkgs.writeShellScriptBin "crcpr" (builtins.readFile ./crcpr))
  ];
}
