# Allow Context7 operations in Pi

Configured Pi permission modes to allow both tools exposed by `@upstash/context7-pi`: `resolve-library-id` and `query-docs`. Default and Plan modes retain first-use prompts for unrelated extension tools, while Build retains its allow-all extension-tool policy.

Validated the JSON syntax and the pinned `pi-permission-modes` 2.2.0 schema. Nix formatting and Home Manager evaluation could not run because this environment provides neither `alejandra` nor `nix`.
