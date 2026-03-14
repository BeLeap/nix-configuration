# Codebase Recommendations (2026-02-21)

## High-Impact Fixes

1. Fix likely `nh` flake path bug (functional)
- File: `config/recipe/nh/default.nix:19`
- Issue: `"nixosConfigurations "` has a trailing space, likely producing an invalid flake reference.

2. Remove debug tracing from shipped scripts (security/noise)
- Files:
  - `config/recipe/overlay/pkgs/beleap-utils/scripts/pip-aerospace:1`
  - `config/recipe/overlay/pkgs/beleap-utils/scripts/aerospace-workspace-change:1`
- Issue: `set -x` may leak command/env details and clutters logs.

3. Fix ineffective git setting typo
- File: `config/recipe/git/default.nix:36`
- Issue: `help.autocorret` is misspelled; use `help.autocorrect`.

4. Improve shell-script safety and portability
- Files:
  - `config/recipe/overlay/pkgs/beleap-utils/scripts/jsb:7`
  - `config/recipe/overlay/pkgs/beleap-utils/scripts/gh-issue:3`
  - `config/recipe/overlay/pkgs/beleap-utils/scripts/pip-aerospace:9`
- Recommendation: add strict mode (`set -euo pipefail`) and quote variable expansions.

## Consistency and Maintainability

5. Align branch defaults with current conventions
- Files:
  - `config/recipe/git/default.nix:38`
  - `config/recipe/overlay/pkgs/beleap-utils/scripts/crcpr:14`
  - `config/recipe/overlay/pkgs/beleap-utils/scripts/crcpr:19`
  - `.github/workflows/build.yml:5`
- Issue: Hardcoded `master`/`develop` may break in repositories using `main`.

6. Make recipe importing actually recursive or rename it
- File: `config/default.nix:17`
- Issue: `recursiveImport` currently imports only one child level.

7. Improve onboarding documentation
- File: `README.md:5`
- Issue: typo (`Configuartion`) and minimal setup guidance for multi-host flake usage.

8. Add lightweight static/eval checks in CI
- File: `.github/workflows/build.yml`
- Recommendation: add `alejandra --check`, `deadnix`, `statix`, and a quick eval check in addition to builds.
