# Add Socratic Tutor skill

- Vendored Jane Street's `socratic-tutor` `SKILL.md` under the generic agent skills recipe.
- Wired the skill to `~/.agents/skills/socratic-tutor` in Home Manager.
- Source: https://github.com/janestreet/agent_skills/blob/master/socratic-tutor/SKILL.md
- Validation: reviewed the source and existing recipe pattern; `jj` is unavailable in this environment, so repository status could not be checked.
- Follow-up: `nix` is also unavailable, so the `jj` fallback and Nix formatting checks could not run.
- Follow-up: replaced the vendored copy in PR #324 with the `janestreet/agent_skills` flake input (`flake = false`) and point Home Manager at its `socratic-tutor` directory. The repository's existing daily `nix flake update` workflow will bump the locked source and open an update PR; no new Actions workflow is needed.
