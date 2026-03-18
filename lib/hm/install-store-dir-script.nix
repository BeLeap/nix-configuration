{
  source,
  targetRelativePath,
}: ''
  target_dir="$HOME/${targetRelativePath}"
  target_parent="$(dirname "$target_dir")"

  run mkdir -p "$target_parent"

  if [[ -e "$target_dir" ]]; then
    # The source tree comes from the Nix store and may have read-only modes.
    run chmod -R u+w "$target_dir"
    run rm -rf "$target_dir"
  fi

  run cp -R ${source} "$target_dir"
  run chmod -R u+rwX "$target_dir"
''
