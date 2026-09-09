# Configure Google Calendar MCP for ZeroClaw

## Outcome

- Added `https://calendarmcp.googleapis.com/mcp/v1` to the Nix-managed `beleap-macmini` ZeroClaw configuration as an HTTP MCP server named `google_calendar`.
- Granted it to the `default` agent through the `google_calendar` MCP bundle.
- Enabled deferred MCP schema loading and auto-approved the read-only `tool_search` discovery step; Calendar tool calls remain subject to the existing supervised approval policy.
- Enabled `calendarmcp.googleapis.com` in the live `beleap-gws` Google Cloud project. `calendar-json.googleapis.com` was already enabled.
- Did not place an OAuth token in the repository. Google requires OAuth 2.0 for Calendar data, while ZeroClaw 0.8.3 accepts static HTTP headers and has no MCP OAuth login flow. The existing `gws` installation currently has no authenticated credentials.

## Validation

- `nix-instantiate --parse config/recipe/beleap-macmini/default.nix` passed.
- Alejandra, Statix, and Deadnix checks passed for the modified recipe.
- Rendered ZeroClaw TOML parsed successfully with Python `tomllib`.
- `nix build .#darwinConfigurations.beleap-macmini.system --accept-flake-config --no-link` passed.
- The Google Calendar MCP endpoint returned HTTP 200 and advertised 9 tools: `list_events`, `get_event`, `list_calendars`, `suggest_time`, `create_event`, `update_event`, `delete_event`, `respond_to_event`, and `search_events`.

## Follow-up

Authenticate the existing Google Workspace CLI with the intended scope, then activate the generated Darwin configuration:

```sh
gws auth login --scopes='https://www.googleapis.com/auth/calendar'
sudo nh darwin switch --flake /Users/beleap/nix-configuration#beleap-macmini
```

The broad `calendar` scope enables write tools; use Google's read-only Calendar scopes instead if ZeroClaw should only inspect the calendar.
