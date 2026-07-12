# Fix jjdescription markdown highlighting in Helix

## Context
- Issue: In `jj` commit description editor, fenced code blocks using ` ```diff ` were not highlighted correctly in Helix.
- Root cause: Helix was not detecting `jj` temporary description files (`*.jjdescription`) as Markdown, so fenced-code language injection (`diff`) never activated.

## Changes made
- Updated `config/recipe/helix/languages.nix`.
- Added a `markdown` language override with `file-types` including a glob for `*.jjdescription`.

## Validation
- Ran: `nix-instantiate --parse config/recipe/helix/languages.nix`
- Result: `OK`

## Notes for next task
- If highlighting still does not apply in a running Helix session, restart Helix after rebuilding/applying Home Manager so language config is reloaded.
