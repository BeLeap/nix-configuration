pkgs:
pkgs.symlinkJoin {
  name = "beleap-utils";
  paths = builtins.map (
    file: pkgs.writeShellScriptBin file (builtins.readFile (./. + "/scripts/${file}"))
  ) (builtins.attrNames (builtins.readDir ./scripts));
}
