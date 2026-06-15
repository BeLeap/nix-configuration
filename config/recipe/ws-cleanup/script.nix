{pkgs}: let
  wsCleanupDays = 30;
  wsPath = "$HOME/ws";
in
  pkgs.writeShellScript "ws-cleanup" ''
    set -euo pipefail

    if [ ! -d "${wsPath}" ]; then
      echo "[ws-cleanup] Skip: ${wsPath} does not exist."
      exit 0
    fi

    echo "[ws-cleanup] Removing first-level directories in ${wsPath} not accessed in the last ${toString wsCleanupDays} days."
    find "${wsPath}" \
      -mindepth 1 \
      -maxdepth 1 \
      -type d \
      -atime +${toString wsCleanupDays} \
      -print \
      -exec rm -rf -- {} +
  ''
