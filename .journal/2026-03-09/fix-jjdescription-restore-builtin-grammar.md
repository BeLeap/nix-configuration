# Fix jjdescription highlighting by restoring built-in grammar

## Problem
- `*.jjdescription`에서 diff 하이라이트가 동작하지 않았음.
- 원인: `languages.nix`에서 `jjdescription`를 `grammar = "markdown"`으로 강제해,
  Helix 내장 `jjdescription` 쿼리(`scissors_inner` 기반)와 충돌.

## Changes
- `config/recipe/helix/languages.nix`
  - `jjdescription` 블록에서 `grammar`/`scope` 제거.
  - `comment-token = "JJ:"` + `file-types`만 유지.
- `config/recipe/helix/default.nix`
  - custom `home.file` query 링크 제거.
- 삭제: `config/recipe/helix/runtime/queries/jjdescription/injections.scm`

## Validation
- `nix-instantiate --parse config/recipe/helix/languages.nix` OK
- `nix-instantiate --parse config/recipe/helix/default.nix` OK
