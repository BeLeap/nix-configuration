#!/usr/bin/env bash
set -euo pipefail

if ! command -v gitleaks >/dev/null 2>&1; then
  echo "gitleaks is required for jj-pre-push checks but was not found in PATH" >&2
  exit 127
fi

for file in "$@"; do
  # Deleted paths have no working-tree contents to scan.
  [[ -f "$file" ]] || continue
  gitleaks dir --redact --exit-code 1 "$file"
done
