# Add scientific debugging agent skill

## Outcome

- Added Agent Skills frontmatter to the source `SKILL.md` with the name `scientific-debugging` and a debugging-focused description.
- Moved the vendored skill out of the Pi recipe into `config/recipe/agent-skills/skills/scientific-debugging`.
- Added the generic `agent-skills` recipe and included it from `development`.
- Wired the skill to `~/.agents/skills/scientific-debugging`, which is shared by coding agents rather than managed as Pi-only state.
- Added OpenAI skill interface metadata alongside the agent-agnostic `SKILL.md`.

## Validation

- Confirmed the source and vendored `SKILL.md` files match.
- Validated required skill frontmatter and OpenAI metadata with Ruby/Psych.
- `nix run nixpkgs#alejandra -- --check config/recipe/agent-skills/default.nix config/recipe/development/default.nix config/recipe/pi/default.nix` passed.
- `nix run nixpkgs#deadnix -- .` passed.
- `nix run nixpkgs#statix -- check .` passed.
- Targeted Nix evaluation confirmed the recipe exposes the expected source and is included by `development`.
- Full `nix flake check --no-build` was blocked while evaluating an unrelated invalid cached `starship-1.25.1.drv` path.

## Follow-up

- Updated the skill to distinguish task scope, constraints, and explicit experiment requests from user-supplied diagnoses, evidence interpretations, and proposed fixes.
- User-supplied diagnoses and proposed fixes are now explicitly treated as opinions or hypotheses to test before implementation.
- Updated the OpenAI default invocation to reinforce this distinction.

## Follow-up validation

- Ruby/Psych validation confirmed the skill frontmatter and OpenAI metadata.
- Reviewed the focused `jj diff --git`; this documentation and metadata-only change requires no build checks.

## Skill review and reorganization

- Reorganized `SKILL.md` so prompt interpretation and the core rule precede the workflow.
- Combined hypothesis ranking with disconfirming-evidence guidance and placed experiment collaboration/update before fix decisions and final review.
- Nested the observation categories under problem framing and standardized list formatting without removing the existing safeguards.

## Review validation

- Read the complete skill after editing and confirmed the workflow order is coherent.
- Ruby/Psych validation confirmed the skill frontmatter.
- No build checks were needed for this documentation-only reorganization.
