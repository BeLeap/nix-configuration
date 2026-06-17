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
          kdash
        ];

        home.shellAliases = {
          k = "kubectl-check";
          ku = "kdash";
        };
      }
    )
  ];
}
