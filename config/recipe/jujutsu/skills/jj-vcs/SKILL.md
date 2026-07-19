---
name: jj-vcs
description: >-
  Use Jujutsu (`jj`) for version-control work: inspect changes and history,
  create atomic commits, split or revise changes, manage bookmarks and remotes,
  rebase, resolve conflicts, and recover with the operation log. Trigger whenever
  a task involves repository state, diffs, commits, history editing,
  branches/bookmarks, fetching, pushing, undoing VCS operations, or translating
  a Git workflow to Jujutsu.
compatibility: Requires the jj CLI and a Jujutsu repository; commands target jj 0.43 or newer.
---

# Jujutsu Version Control

Use this skill as a command and workflow reference when Jujutsu has already been selected by the user's or project's instructions. Jujutsu automatically snapshots the working copy into the current revision (`@`), so there is no staging area and no need to make a temporary commit before inspecting or editing.

## Core Rules

1. Start with `jj root`, `jj status`, and a focused `jj diff --git`. Inspect existing work before changing history.
2. Preserve changes you did not create. Never restore, abandon, squash, split, describe, or commit someone else's work merely to obtain a clean state.
3. Keep each described revision atomic. Before describing or committing, verify its exact diff and separate unrelated changes.
4. Prefer change IDs shown by `jj log` over commit IDs: change IDs remain stable when revisions are rewritten.
5. Quote revsets containing operators, such as `'@::'`, `'main..@'`, or `'roots(main..@)'`.
6. `jj git ...` is Jujutsu's interface for Git interoperability operations such as fetch and push.
7. Do not fetch, push, move/delete bookmarks, rewrite shared history, or restore an operation unless the user requested it or it is clearly necessary and approved.
8. Before a push, run `jj git fetch --remote <remote>`, inspect outgoing revisions, and use `jj git push --dry-run ...` before the real push.
9. On uncertain syntax, run `jj help <command>` rather than guessing. Do not search external documentation until the bundled reference and CLI help are insufficient.

## Default Workflow

### 1. Inspect

```bash
jj root
jj status
jj diff --git
jj log -r 'ancestors(@, 8) | @::' --limit 20
```

Scope the diff to task-owned paths where useful:

```bash
jj diff --git -- path/to/file another/path
```

If `jj status` reports pre-existing changes, identify and preserve them. Do not claim them as task work.

### 2. Implement and validate

Edit files normally. `jj` snapshots them automatically on the next command. Re-run focused status and diff checks throughout the task:

```bash
jj status
jj diff --summary
jj diff --git -- path/to/changed/files
```

Run project tests independently of VCS operations.

### 3. Record an atomic revision only when requested

If the current revision contains exactly one logical change:

```bash
jj describe -m "Concise imperative description"
```

To describe the current revision and open a new empty child:

```bash
jj commit -m "Concise imperative description"
```

When only whole task-owned paths should remain in the current revision and unrelated paths should move into the new child:

```bash
jj commit path/to/owned-file another/path -m "Concise imperative description"
```

Use `jj split -i` when separation requires selecting hunks. Do not automate an interactive split unless the environment supports the configured diff editor. After any history edit, inspect `jj status`, `jj diff`, and `jj log` again.

### 4. Report

Report the change ID and description if a revision was recorded. Distinguish task changes from pre-existing working-copy changes and state whether anything was pushed.

## Recovery and Failure Handling

Jujutsu records repository-changing commands in its operation log:

```bash
jj op log
jj undo
```

`jj undo` reverses the most recent operation; inspect first because the latest operation may belong to another concurrent process. For older recovery points, inspect with `jj --at-op=<operation-id> status` before considering `jj op restore <operation-id>`.

Conflicts are first-class repository state. Do not hide or discard them:

```bash
jj resolve --list
jj diff --git
```

Resolve files manually or with `jj resolve <paths>`, then verify `jj resolve --list` is empty and run relevant tests.

## Reference

Load [references/command-reference.md](references/command-reference.md) for exact recipes covering inspection, revision creation and editing, revsets, bookmarks, remotes, rebasing, conflicts, workspaces, and recovery.
