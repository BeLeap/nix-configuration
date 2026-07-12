# Reduce Starship Scan Timeout

- Set `programs.starship.settings.scan_timeout = 1` in `config/recipe/starship/default.nix`.
- Goal: make prompt startup stop waiting on directory scans almost immediately when entering slow or large directories.
- Tradeoff: Starship modules that rely on filesystem scanning may fail to detect some project context more often.
