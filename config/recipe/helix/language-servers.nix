{
  pkgs,
  lib,
  ...
}: {
  biome = {
    command = "${lib.getExe pkgs.biome}";
    args = ["lsp-proxy"];
    required-root-patterns = ["biome.json"];
  };
  kmp-lsp = {
    command = "${lib.getExe pkgs.kmp-lsp}";
  };
  typescript-language-server = with pkgs; {
    command = "${lib.getExe typescript-language-server}";
    args = [
      "--stdio"
    ];
  };
  nil = {
    command = "${lib.getExe pkgs.nil}";
  };
  helm-ls = {
    command = "${lib.getExe pkgs.helm-ls}";
    args = ["serve"];
  };
}
