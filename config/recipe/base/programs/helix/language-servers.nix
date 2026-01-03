{ pkgs, lib, ... }:
{
  biome = {
    command = "${lib.getExe pkgs.biome}";
    args = [ "lsp-proxy" ];
    required-root-patterns = [ "biome.json" ];
  };
  kotlin-ls = {
    command = "${lib.getExe pkgs.kotlin-ls}";
    args = [ "--stdio" ];
    timeout = 60;
    required-root-pattern = [
      "build.gradle"
      "build.gradle.kts"
      "pom.xml"
    ];
  };
  typescript-language-server = with pkgs.nodePackages; {
    command = "${lib.getExe typescript-language-server}";
    args = [
      "--stdio"
    ];
  };
  nil = {
    command = "${lib.getExe pkgs.nil}";
  };
}
