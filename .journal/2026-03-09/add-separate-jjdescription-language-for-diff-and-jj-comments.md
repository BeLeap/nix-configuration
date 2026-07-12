# Add separate jjdescription language for diff and `JJ:` comments

## Request
- Remove markdown-level mapping hack.
- Keep fenced `diff` highlighting and make `JJ:` lines comment tokens in `*.jjdescription`.

## Changes made
- Updated `config/recipe/helix/languages.nix`.
- Removed `*.jjdescription` from `markdown.file-types`.
- Added a dedicated language block:
  - `name = "jjdescription"`
  - `grammar = "markdown"`
  - `scope = "source.markdown"`
  - `comment-tokens = ["JJ:"]`
  - `file-types = [{ glob = "*.jjdescription"; }]`

## Validation
- Ran: `nix-instantiate --parse config/recipe/helix/languages.nix`
- Result: `OK`
