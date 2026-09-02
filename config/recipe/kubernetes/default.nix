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
        ];

        programs.k9s = {
          enable = true;
          package = pkgs.unstable.k9s;

          settings = {
            k9s = {
              ui.skin = "gruvbox";
              skipLatestRevCheck = true;
              maxConnRetry = 3;
            };
          };

          skins = {
            gruvbox = ./gruvbox.yaml;
          };
        };

        home.shellAliases = {
          k = "kubectl-check";
          ku = "k9s";
        };
      }
    )
  ];
}
