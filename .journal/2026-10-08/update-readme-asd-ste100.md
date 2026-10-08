# Update README to ASD-STE100 style

## Outcome

- Rewrote `README.md` prose with short sentences, direct instructions, active voice, and consistent terms.
- Preserved repository paths, command examples, and the recipe graph contract.

## Validation

- Checked all local README paths. Every referenced path exists.
- Checked for trailing whitespace, semicolons, and common contractions. No matches appeared.
- Inspected the `jj` diff. Only `README.md` changed.
- No Markdown linter configuration exists in the repository.
- `jj diff --check` is not supported by the installed `jj` command. The shell whitespace check passed instead.
- No formal ASD-STE100 checker or controlled-vocabulary audit was available.

Correction: The task diff includes this journal entry. `README.md` is the only product file changed.
