{ kubectl-check, ... }:
final: prev:

{
  beleap-utils = import ./beleap-utils prev;
  kubectl-check = kubectl-check.packages.${prev.system}.default;
}
