{ pkgs, ... }:
{
  biome = {
    command = "biome";
    args = [ "lsp-proxy" ];
    required-root-patterns = [ "biome.json" ];
  };
  kotlin-ls = {
    command = "kotlin-ls";
    args = [ "--stdio" ];
    timeout = 60;
    required-root-pattern = [
      "build.gradle"
      "build.gradle.kts"
      "pom.xml"
    ];
  };
  typescript-language-server = with pkgs.nodePackages; {
    command = "${typescript-language-server}/bin/typescript-language-server";
    args = [
      "--stdio"
    ];
  };
  nil = {
    command = "${pkgs.nil}/bin/nil";
  };
}
