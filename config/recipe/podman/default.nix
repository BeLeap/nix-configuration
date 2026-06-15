_: {
  hm = [
    (
      {pkgs, ...}: {
        home.packages = with pkgs; [
          podman
          podman-compose
        ];
        home.shellAliases = {
          docker = "podman";
        };
      }
    )
  ];
}
