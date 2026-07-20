# Add i-have-adhd to Pi

Added `https://github.com/ayghri/i-have-adhd` to Pi's declarative global
package list. Pi will clone the repository and discover its conventional
`skills/i-have-adhd/SKILL.md` resource, making the skill available without a
mutable `pi install` change.

Verification: `git diff --check` passes. The environment does not provide the
`alejandra` or `nix` executables, so formatting and Home Manager evaluation
could not be run locally.
