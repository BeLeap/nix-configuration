# Exclude whitespace from WezTerm push quick select

- Changed the `push-` quick-select regular expression to stop matching at whitespace.
- Used a Lua long string so the regular expression's `\S` token is passed to WezTerm without additional escaping.
- Validated the configuration syntax and the pattern's matching behavior.
