{
  kubectl-check,
  boda,
  ...
}: final: prev: {
  beleap-utils = import ./beleap-utils prev;
  kubectl-check = kubectl-check.packages.${prev.stdenv.hostPlatform.system}.default;
  boda = boda.packages.${prev.stdenv.hostPlatform.system}.default;
  joplin-cli = prev.joplin-cli.overrideAttrs (finalAttrs: prevAttrs: {
    postInstall =
      (prevAttrs.postInstall or "")
      + ''
        appCliApp="$out/lib/packages/app-cli/app"
        packageJson="$appCliApp/package.json"
        if [ ! -f "$packageJson" ]; then
          mkdir -p "$appCliApp"
          printf '%s\n' '{"version":"${finalAttrs.version}"}' >"$packageJson"
        fi
      '';
  });
}
