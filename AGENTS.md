# Agent Instructions

These instructions apply across the repository. See [README.md](README.md#for-coding-agents)
for project structure, Nix commands, and change workflow.

## Understand the request

- Review the relevant files and existing patterns before editing.
- Make assumptions explicit. Ask when an ambiguity would materially change the solution; otherwise use the simplest reasonable interpretation.
- For multi-step work, state a short plan and define what will show the request is complete.

## Keep changes focused

- Make the smallest complete change. Avoid speculative features, abstractions, and configurability.
- Preserve existing behavior and style. Don't refactor or reformat unrelated code.
- Remove only things made unnecessary by your own changes; report unrelated issues without changing them.

## Verify the result

- Check the finished change against the request and run the relevant checks documented in the README.
- Report which checks ran and surface any failures or limitations; don't imply that unchecked work passed.

Some of these working principles are adapted from [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills/blob/main/CLAUDE.md).
