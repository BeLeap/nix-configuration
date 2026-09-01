# Allow Context7 operations in Pi

Configured Pi permission modes to allow the `context7-docs` skill and both tools exposed by `@upstash/context7-pi`: `resolve-library-id` and `query-docs`. This prevents the skill activation that precedes the tool calls from prompting for approval. Default and Plan modes retain first-use prompts for unrelated skills and extension tools, while Build retains its allow-all policies.

Validated the JSON syntax and the pinned `pi-permission-modes` 2.2.0 schema. The first schema-validation attempt could not run because Python's `jsonschema` module is unavailable; validation was rerun successfully with `ajv-cli`. Nix formatting and Home Manager evaluation could not run because this environment provides neither `alejandra` nor `nix`.
