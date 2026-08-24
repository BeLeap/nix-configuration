_: {
  home = [
    (
      {pkgs, ...}: {
        home.packages = with pkgs; [
          kubectl
          kubelogin-oidc
          kubectl-node-shell
          kubectl-view-secret
          kubectl-view-allocations
          kubectl-sniff
          kubectl-check
          kubernetes-helm
          kind
          unstable.k9s
        ];

        home.shellAliases = {
          k = "kubectl-check";
          ku = "k9s";
        };
      }
    )
  ];
}
