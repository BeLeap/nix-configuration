{ kubectl-check, boda, ... }:
final: prev:

{
  beleap-utils = import ./beleap-utils prev;
  kubectl-check = kubectl-check.packages.${prev.stdenv.hostPlatform.system}.default;
  boda = boda.packages.${prev.stdenv.hostPlatform.system}.default;
}
