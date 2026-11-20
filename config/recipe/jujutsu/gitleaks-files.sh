set -euo pipefail

for file in "$@"; do
  # Deleted paths have no working-tree contents to scan.
  [[ -f "$file" ]] || continue
  gitleaks dir --redact --exit-code 1 "$file"
done
