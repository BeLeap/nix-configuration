## Opencode Permission Rules

- Changed the `opencode` recipe to allow file edits in the working directory by setting `permission.edit = "allow"`.
- Kept `permission.external_directory = "ask"` so edits outside the working directory still require approval.
- Changed `permission.bash` to ask by default while allowing common read-only `jj` commands such as `jj status`, `jj diff`, `jj log`, and `jj show`.
