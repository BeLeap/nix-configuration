# Adjust jjdescription scope to diff highlighting only

## Decision
- Scoped requirement to only keep fenced `diff` highlighting in `*.jjdescription`.
- Did not keep `JJ:` comment token customization.

## Changes made
- Updated `config/recipe/helix/languages.nix`.
- Removed previously added `markdown.comment-tokens` override.
- Kept `*.jjdescription` mapped to `markdown` so fenced diff blocks continue to highlight.

## Validation
- Ran: `nix-instantiate --parse config/recipe/helix/languages.nix`
- Result: `OK`
