# `jj` Command Reference

This reference targets Jujutsu 0.43. Prefer `jj help <command>` if the installed version differs or an option is unclear.

## Mental Model

- `@` is the working-copy revision; `@-` is its parent and `@--` its grandparent.
- Normal `jj` commands snapshot filesystem changes into `@` automatically.
- There is no staging area. `jj commit` describes `@` and creates a new child; path arguments select which changes stay in the described revision.
- A **change ID** identifies the evolving logical change and normally survives rewrites. A **commit ID** identifies one immutable version of it.
- Descendants are automatically rebased when an ancestor is rewritten.
- Bookmarks are explicit movable names similar to Git branches, but they do not automatically follow new commits.

## Inspect State and History

```bash
jj root                              # repository root
jj status                            # working-copy state and conflicts
jj diff                              # diff of @ against its parent
jj diff --git                        # portable Git-format diff
jj diff --summary                    # changed-path summary
jj diff --git -- path/to/file        # focused fileset
jj diff -r <rev>                     # a revision's changes
jj diff --from <a> --to <b>          # tree difference
jj show <rev>                        # revision metadata and patch
jj log                               # configured history view
jj log -r '<revset>'                 # selected revisions
jj log -r 'ancestors(@, 8)'          # current revision plus seven ancestors
jj log -r 'main..@'                  # revisions reachable from @ but not main
jj file list                         # tracked files in @
```

For scripts, disable color and graph noise explicitly:

```bash
jj log --no-graph --color never -r @ -T 'change_id ++ "\n"'
```

## Create and Describe Revisions

```bash
jj describe -m "message"             # describe @ without creating a child
jj describe -r <rev> -m "message"    # describe another mutable revision
jj new                               # create and edit an empty child of @
jj new <rev>                         # create and edit an empty child of rev
jj commit -m "message"               # describe @ and create an empty child
jj commit <filesets> -m "message"    # keep selected paths in @; move rest to child
jj edit <change-id>                   # make an existing revision the working copy
```

Use descriptions in imperative form and keep one intent per revision. Avoid `jj new` merely to imitate a Git pre-edit branch or staging workflow.

## Separate, Combine, and Move Changes

```bash
jj split <filesets> -m "message"      # selected paths first, remainder in child
jj split -i                           # interactively select hunks
jj split -r <rev> <filesets>          # split another mutable revision
jj squash                             # move all changes from @ into @-
jj squash <filesets>                  # move selected paths from @ into @-
jj squash -i                          # interactively move selected hunks into @-
jj squash --from <a> --into <b>       # explicit source and destination
jj abandon <revset>                   # remove revisions; descendants rebase
```

Inspect the resulting graph and diffs after every rewrite. `jj abandon` does not delete the filesystem changes of descendants, but it is still destructive history editing and should not be used on unrelated work.

## Restore Content

```bash
jj restore <filesets>                 # restore paths in @ from @-
jj restore -i                         # choose portions interactively
jj restore --from <src> <filesets>    # copy paths from src into @
jj restore --from <src> --into <dst> <filesets>
jj restore --changes-in <rev>         # reverse rev's changes in @
```

Always inspect the diff first. `jj restore` without filesets restores all paths in `@` from its parents, which can discard the entire current diff.

## Useful Revsets

Quote revsets in the shell.

| Revset | Meaning |
|---|---|
| `@`, `@-`, `@--` | working copy, parent, grandparent |
| `<x>+`, `<x>-` | children, parents |
| `<x>::` | descendants including x |
| `::<x>` | ancestors including x |
| `x..y` | ancestors of y excluding ancestors of x |
| `ancestors(<x>, 5)` | x and up to four ancestor generations |
| `roots(<set>)` | members with no parent also in the set |
| `heads(<set>)` | members with no child also in the set |
| `bookmarks()` | local bookmark targets |
| `conflicts()` | conflicted revisions |
| `mine()` | revisions authored by the configured user |
| `mutable()` | revisions allowed to be rewritten |
| `description(glob:"text*")` | revisions matching description text |

Examples:

```bash
jj log -r 'main..@'
jj log -r 'roots(main..@)'
jj log -r 'conflicts() & mine()'
```

## Rebase and Stack Editing

```bash
jj rebase -b @ -o main               # current branch onto main
jj rebase -s <rev> -o <dest>         # rev and descendants onto dest
jj rebase -r <revset> -o <dest>      # only selected revisions; preserve dependencies
jj rebase -r <rev> -A <after>        # insert selected revision after target
jj rebase -r <rev> -B <before>       # insert selected revision before target
```

`-b` selects the whole branch relative to the destination, `-s` selects a revision and descendants, and `-r` selects only named revisions. Inspect `jj log` before choosing among them.

## Bookmarks

```bash
jj bookmark list --all-remotes
jj bookmark create <name> -r <rev>
jj bookmark set <name> -r <rev>      # create or move by name
jj bookmark move <name> --to <rev>   # move existing bookmark
jj bookmark advance <name> --to <rev>
jj bookmark track <name>@<remote>
jj bookmark untrack <name>@<remote>
jj bookmark rename <old> <new>
jj bookmark delete <name>            # records deletion for next push
jj bookmark forget <name>            # remove locally without remote deletion
```

Use `forget`, not `delete`, when the remote bookmark must remain untouched. Bookmarks do not move merely because `jj new` or `jj commit` creates a child.

## Fetch and Push

```bash
jj git fetch --remote origin
jj git fetch --all-remotes
jj log -r 'main@origin..@'

jj git push --remote origin --bookmark <name> --dry-run
jj git push --remote origin --bookmark <name>
```

Alternatives for creating a remote bookmark:

```bash
jj git push --remote origin --named '<name>=<rev>' --dry-run
jj git push --remote origin --change <rev> --dry-run
```

Push safety:

1. Fetch the intended remote.
2. Inspect bookmarks and outgoing revisions.
3. Ensure every pushed revision has a meaningful description and no unresolved conflict.
4. Run the exact push with `--dry-run`.
5. Run it again without `--dry-run` only after the preview matches intent.

Avoid broad `--all`, `--tracked`, or `--deleted` pushes unless broad remote changes are explicitly intended. Jujutsu push uses lease-like safety checks but can still rewrite a bookmark intentionally.

## Conflicts

```bash
jj resolve --list                    # list conflicted paths in @
jj log -r 'conflicts()'              # find conflicted revisions
jj resolve <filesets>                # open configured merge tool
jj resolve --tool :ours <path>       # choose side 1 deliberately
jj resolve --tool :theirs <path>     # choose side 2 deliberately
```

Conflicts may also be resolved by editing conflict markers directly. Verify with `jj resolve --list`, inspect the diff, and run tests. Never choose `:ours` or `:theirs` just to silence a conflict.

## Operation Log and Recovery

```bash
jj op log                            # repository operation history
jj op show <operation-id>
jj op diff --operation <id>          # inspect operation-level changes
jj --at-op=<id> status               # inspect old state without restoring it
jj undo                              # reverse the latest operation
jj op restore <operation-id>         # restore repository to an older operation
```

Check `jj op log` immediately before `jj undo`; automatic snapshots and concurrent tools can make the latest operation different from the one expected. Operation restoration affects repository state broadly and requires explicit care.

## Workspaces

```bash
jj workspace list
jj workspace add <path> -r <rev>
jj workspace root
jj workspace update-stale
jj workspace forget <name>
```

Use a separate workspace for parallel or isolated work when modifying the same working-copy revision would mix responsibilities. Each workspace has its own working-copy revision but shares repository history.

## Configured Short Aliases

This configuration provides:

```text
d=describe  n=new  st=status  l=log --limit=20  df=diff  e=edit
p=git push  f=git fetch --all-remotes  b=bookmark  ba=bookmark advance
sq=squash -i  wl=workspace list  wa=workspace add  wf=workspace forget
wr=workspace root  wus=workspace update-stale
```

Prefer full command names in automation and reports because they are self-documenting and portable.

## Git-to-Jujutsu Translation

| Git intent | Jujutsu command |
|---|---|
| `git status` | `jj status` |
| `git diff` | `jj diff --git` |
| `git log` | `jj log` |
| `git add` | unnecessary; use filesets with `jj commit`/`split` |
| `git commit -m ...` | `jj commit -m ...` |
| amend current commit | edit files in `@`, or `jj squash` into `@-` |
| `git checkout <branch>` | `jj new <bookmark>` or `jj edit <change>` depending intent |
| create/move branch | `jj bookmark create/set` |
| `git fetch` | `jj git fetch` |
| `git push` | `jj git push` |
| `git rebase` | `jj rebase` |
| `git reset --hard` | inspect first; usually `jj restore` or operation recovery |
| `git reflog` | `jj op log` |
