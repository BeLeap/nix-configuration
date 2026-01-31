_: {
  hm = [
    (
      {
        pkgs,
        lib,
        metadata,
        ...
      }:
      {
        home.packages =
          with pkgs;
          [
            kubectl
            kubectl-node-shell
            kubectl-view-secret
            kubectx
            kubectl-check
            kubernetes-helm
            kind
          ]
          ++ (lib.optionals (!(metadata.os == "linux" && metadata.arch == "aarch64")) [
            pkgs.kubectl-sniff
          ]);

        programs.k9s = {
          enable = true;

          settings = {
            k9s = {
              skin = "catppuccin-frappe";
              skipLatestRevCheck = true;
              maxConnRetry = 3;
            };
          };

          skins = {
            catppuccin-frappe = ./catppuccin-frappe.yaml;
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
