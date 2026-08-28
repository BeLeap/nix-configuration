# Encode safety and assumption preferences

- Updated the shared agent instructions to prefer safe, explicit failure over
  success at any cost.
- Added a requirement to identify, explain, and verify assumptions and to favor
  designs that minimize reliance on them.
- Aligned the journal instruction with the `journal/<date>/<title>.md` location.

## Validation

- Reviewed the focused diff and checked the updated Markdown for trailing
  whitespace and formatting errors with `git diff --check`.
