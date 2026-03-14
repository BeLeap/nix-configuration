# Vendor Joplin Codex Skill Into Joplin Recipe

## Summary

- Vendored the `joplin-cli` Codex skill into this repository under `config/recipe/joplin/skills/joplin-cli`.
- Updated the Joplin Home Manager recipe to install the skill at `~/.agents/skills/joplin-cli` using a recursive `home.file` source.
- Replaced machine-specific absolute references in `SKILL.md` with repo-local relative paths so the skill works on any host managed by this repository.

## Verification

- Checked Home Manager docs for the `home.file.<name> = { source = ./dir; recursive = true; };` pattern before wiring the directory into the recipe.
- Checked the current OpenAI Codex skills docs and aligned the install path with the documented user scope skill directory, `$HOME/.agents/skills`.
