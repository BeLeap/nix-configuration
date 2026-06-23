_: {
  hm = [
    (
      {
        pkgs,
        lib,
        metadata,
        ...
      }: {
        home.packages = with pkgs; [
          kubectl
          kubectl-node-shell
          kubectl-view-secret
          kubectl-view-allocations
          kubectl-sniff
          kubectl-check
          kubernetes-helm
          kind
          k9s
        ];

        home.shellAliases = {
          k = "kubectl-check";
          ku = "k9s";
        };
      }
    )
  ];
}
