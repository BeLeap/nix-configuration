_: {
  home = [
    (
      {pkgs, ...}: {
        home = {
          packages = with pkgs; [
            kubectl
            kubectl-rexec
            kubelogin-oidc
            kubectl-node-shell
            kubectl-view-secret
            kubectl-view-allocations
            kubectl-sniff
            kubectl-check
            kubernetes-helm
            kind
          ];

          file.".kube/kuberc".source = ./kuberc.yaml;

          shellAliases = {
            k = "kubectl-check";
            ku = "k9s";
          };
        };

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
      }
    )
  ];
}
