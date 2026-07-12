# Fix jjdescription fenced diff injection highlighting

## Symptom
- In `*.jjdescription`, fenced code blocks like ` ```diff ` had no syntax highlighting.

## Root cause
- `jjdescription` is a custom language; markdown injection queries were not available under `queries/jjdescription/`.
- Without an `injections.scm` query for this language name, fenced-code language injection did not activate.

## Changes made
- Added runtime query file:
  - `config/recipe/helix/runtime/queries/jjdescription/injections.scm`
  - Content mirrors markdown injection rules for fenced blocks.
- Wired the file into Home Manager:
  - `config/recipe/helix/default.nix`
  - `home.file.".config/helix/runtime/queries/jjdescription/injections.scm".source = ./runtime/queries/jjdescription/injections.scm;`

## Existing language config retained
- `jjdescription` stays separate from markdown in `config/recipe/helix/languages.nix`.
- Keeps `comment-token = "JJ:"` and `grammar = "markdown"`.

## Validation
- Ran: `nix-instantiate --parse config/recipe/helix/default.nix`
- Result: `OK`
- Ran: `nix-instantiate --parse config/recipe/helix/languages.nix`
- Result: `OK`
