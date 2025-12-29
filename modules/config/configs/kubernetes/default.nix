{
  common = {
    hm =
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
            };
          };

          skins = {
            catppuccin-frappe = ./catppuccin-frappe.yaml;
          };
        };
      };
  };
}
