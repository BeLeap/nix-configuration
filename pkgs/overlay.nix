{ kubectl-check, boda, ... }:
final: prev:
let
  system = prev.stdenv.hostPlatform.system;
in
{
  beleap-utils = import ./beleap-utils prev;
  kubectl-check = kubectl-check.packages.${system}.default;
  boda = boda.packages.${system}.default;
}
