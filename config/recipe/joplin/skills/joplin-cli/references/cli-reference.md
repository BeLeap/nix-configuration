# Joplin CLI Reference

Use this file for quick command recall. Prefer `joplin help <command>` before running a command you are not fully sure about.

## Help and Inspection

```bash
joplin help
joplin help all
joplin help <command>
```

## Mandatory Sync Boundaries

Run before reads:

```bash
joplin sync
```

Run again after any modification:

```bash
joplin sync
```

If either sync fails, stop and report the error.

## Common Shell-Mode Commands

### Discover notebooks, notes, and IDs

```bash
joplin status
joplin ls /
joplin ls -l
joplin use "Notebook Name"
```

- `joplin ls /` lists notebooks.
- `joplin ls -l` shows long format, including IDs useful for precise updates.
- `joplin use "Notebook Name"` switches the current notebook for subsequent operations.

### Search and read

```bash
joplin search "query"
joplin cat <note>
joplin cat -v <note>
```

- Use `cat -v` when metadata matters.
- Prefer IDs when multiple notes share similar titles.

### Create content

```bash
joplin mkbook "Notebook Name"
joplin mknote "Note Title"
joplin mktodo "Todo Title"
```

Typical notebook-scoped flow:

```bash
joplin sync
joplin mkbook "Project Notes"
joplin use "Project Notes"
joplin mknote "Kickoff"
joplin sync
```

### Update and organize

```bash
joplin set <note> title "New title"
joplin set <note> body "Updated body text"
joplin mv <note> "Notebook Name"
joplin ren <item> "New name"
```

`joplin set <note> <name> [value]` supports properties including `title`, `body`, `is_todo`, `todo_due`, and `todo_completed`.

### Tags and todos

```bash
joplin tag list
joplin tag add "tag-name" <note>
joplin tag remove "tag-name" <note>
joplin tag notetags <note>
joplin done <note>
joplin undone <note>
joplin todo toggle <note>
```

### Delete only with clear intent

```bash
joplin rmnote <note>
joplin rmbook <notebook>
```

Prefer IDs and avoid force flags unless the user explicitly wants non-interactive deletion.

## Operating Notes

- Shell mode supports both titles and IDs, but IDs are safer for mutations.
- The terminal UI also supports `help`, `help keymap`, and `help <command>` in command-line mode.
- The official docs note `joplin help all` for shell-mode command discovery and `joplin ls -l` for viewing IDs.

## Sources

- Joplin terminal app docs: https://joplinapp.org/help/apps/terminal/
