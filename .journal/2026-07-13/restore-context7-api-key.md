# Restore Context7 API key

- Restored the encrypted `context7-api-key.age` from the parent of commit `82ab21a9009bed32e8bd9ba38edd51d41f3c2c1e`, where it was deleted with the OpenCode recipe.
- Moved ownership to `config/recipe/pi/secrets/` along with its agenix declaration.
- Updated the Pi recipe to reference its local secret path.
- `jj` was unavailable because its secure repository metadata could not be accessed in the execution sandbox, so read-only `git show` was used to recover the deleted files.
