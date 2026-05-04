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
        ];

        programs.k9s = {
          enable = true;

          settings = {
            k9s = {
              skin = "catppuccin-mocha";
              skipLatestRevCheck = true;
              maxConnRetry = 3;
            };
          };

          skins = {
            catppuccin-mocha = ./catppuccin-mocha.yaml;
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
