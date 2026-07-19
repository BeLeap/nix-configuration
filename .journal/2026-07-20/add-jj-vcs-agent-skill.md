# Add Jujutsu VCS agent skill

Created a declaratively installed `jj-vcs` agent skill under the Jujutsu recipe so coding agents can use Jujutsu without repeatedly researching routine commands.

## Outcome

- Wired `config/recipe/jujutsu/skills/jj-vcs` to `~/.agents/skills/jj-vcs` through Home Manager.
- Added a focused `SKILL.md` covering Jujutsu's working-copy model, safe inspection, preservation of unrelated changes, atomic revision creation, push safeguards, conflict handling, and operation-log recovery.
- Kept the preference for Jujutsu as the daily VCS in `AGENTS.md`; the skill only supplies Jujutsu mechanics after project or user policy has selected it.
- Added a detailed on-demand command reference for inspection, revision editing, revsets, rebasing, bookmarks, remotes, conflicts, workspaces, recovery, configured aliases, and Git-to-Jujutsu translation.
- Added OpenAI skill metadata for discovery and explicit `$jj-vcs` invocation.
- Verified command forms against the installed Jujutsu 0.43 CLI and the official `/websites/jj-vcs_dev` Context7 documentation.

## Validation

- Parsed both YAML documents and validated required skill metadata, name/description constraints, and local Markdown links with Ruby.
- `alejandra --check config/recipe/jujutsu/default.nix` passed.
- Reviewed the focused `jj diff --git` for the Jujutsu recipe and skill files.
- `nix fmt` and Nix evaluation were blocked by sandbox restrictions: Nix could not write its fetcher cache under `~/.cache/nix`; attempts to redirect its cache were also denied access to temporary storage and the Nix daemon socket.

## Notes

The working copy already contained unrelated Pi and journal changes. They were left untouched and are not part of this task.
