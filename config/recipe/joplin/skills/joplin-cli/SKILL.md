---
name: joplin-cli
description: Use Joplin CLI to search, read, create, update, organize, and sync notes, notebooks, tags, and to-dos in a Joplin knowledge base. Trigger this skill when Codex should work through the `joplin` terminal command instead of editing exported files directly, especially for knowledge-base lookup, note summarization, todo management, notebook organization, tagging, or any task where the user expects `joplin sync` before reads and after modifications.
---

# Joplin CLI

Use the `joplin` terminal client as the source of truth for the user's notes and to-dos. Treat synchronisation as mandatory state management, not as a best-effort cleanup step.

## Core Rules

1. Run `joplin sync` before any read operation.
2. Run `joplin sync` after any operation that creates, edits, moves, renames, tags, completes, or deletes content.
3. If a sync fails, stop and surface the failure clearly. Do not continue with stale local state.
4. Prefer `joplin help`, `joplin help all`, and `joplin help <command>` whenever the exact command shape is uncertain.
5. Prefer note IDs over titles for destructive or ambiguous operations. Use `joplin ls -l` or other long-format output to capture IDs before mutating data.
6. If multiple notes match a title or search term, disambiguate before making changes.

## Workflow

### 1. Refresh state

Start every task with:

```bash
joplin sync
```

Only proceed once sync succeeds.

### 2. Discover the right command

Use help-first discovery rather than guessing:

```bash
joplin help
joplin help all
joplin help <command>
```

When working with an unfamiliar subcommand, inspect its help before execution.

### 3. Locate the target content

Use Joplin itself to find notebooks, notes, tags, and to-dos. Common patterns:

- Search for matching notes.
- List notebooks, notes, or tags in long format to capture IDs.
- Switch notebook context before creating new content when needed.

Load [cli-reference.md](references/cli-reference.md) for common command patterns.

### 4. Read or summarize

After the initial sync, read from Joplin using CLI commands such as note display, notebook listings, tag listings, or status summaries. Summaries should be based on synced Joplin content, not stale assumptions.

### 5. Modify carefully

For create and update operations:

- Choose the notebook first when notebook placement matters.
- Use explicit commands for note creation, todo creation, renaming, property updates, moves, and tags.
- For risky changes, capture the item ID first.
- Surface exactly what changed.

### 6. Re-sync immediately

After any mutation, run:

```bash
joplin sync
```

Do not report completion until the post-write sync succeeds or fails explicitly.

## Task Patterns

### Search and summarize notes

1. Run `joplin sync`.
2. Search for the relevant notes.
3. Read the matched notes.
4. Summarize findings, citing note titles or IDs when useful.

### Create a note or todo

1. Run `joplin sync`.
2. Select or switch to the destination notebook if needed.
3. Create the note or todo.
4. Apply follow-up metadata such as tags or title fixes.
5. Run `joplin sync` again.

### Update existing content

1. Run `joplin sync`.
2. Find the target note and capture its ID.
3. Apply the minimal required change.
4. Run `joplin sync` again.

### Organize notebooks and tags

1. Run `joplin sync`.
2. Inspect notebooks, note IDs, and current tags.
3. Move, rename, or retag the intended items.
4. Run `joplin sync` again.

## Failure Handling

- Fail loudly on sync errors, ambiguous matches, missing notebooks, or invalid commands.
- Do not silently create duplicate notes when a likely existing note should be updated.
- Do not bypass Joplin by editing its profile database or sync target files directly unless the user explicitly asks for low-level recovery work.

## Reference

Read [cli-reference.md](references/cli-reference.md) for a concise command reference and example shell-mode workflows.
