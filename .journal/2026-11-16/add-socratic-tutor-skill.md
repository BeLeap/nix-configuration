# Add Socratic Tutor skill

- Vendored Jane Street's `socratic-tutor` `SKILL.md` under the generic agent skills recipe.
- Wired the skill to `~/.agents/skills/socratic-tutor` in Home Manager.
- Source: https://github.com/janestreet/agent_skills/blob/master/socratic-tutor/SKILL.md
- Validation: reviewed the source and existing recipe pattern; `jj` is unavailable in this environment, so repository status could not be checked.
- Follow-up: `nix` is also unavailable, so the `jj` fallback and Nix formatting checks could not run.
