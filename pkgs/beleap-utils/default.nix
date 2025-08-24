pkgs:

pkgs.symlinkJoin {
  name = "beleap-utils";
  paths = [
    (pkgs.writeShellScriptBin "crcpr" (builtins.readFile ./crcpr))
    (pkgs.writeShellScriptBin "fco" (builtins.readFile ./fco))
    (pkgs.writeShellScriptBin "fcd" (builtins.readFile ./fcd))
    (pkgs.writeShellScriptBin "jjcp" (builtins.readFile ./jjcp))
    (pkgs.writeShellScriptBin "gh-issue" (builtins.readFile ./gh-issue))
  ];
}
