{ kubectl-check, boda, ... }:
final: prev:

{
  beleap-utils = import ./beleap-utils prev;
  kubectl-check = kubectl-check.packages.${prev.system}.default;
  boda = boda.packages.${prev.system}.default;
  kotlin-ls = prev.callPackage ./kotlin-ls { };
  wezterm-null = import ./wezterm-null prev;
}
