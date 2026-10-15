---
name: agent-browser
description: >-
  Use the agent-browser CLI to automate live websites and web apps, including
  navigation, interaction, data extraction, screenshots, and browser-flow
  testing. Not for ordinary web searches or reading local files.
---

# agent-browser

Use this skill for browser automation. The `agent-skills` recipe installs
`agent-browser` into the user's profile, making it available to agents that
use that environment.

Before using the CLI, load the workflow guidance that matches the installed
version:

```bash
agent-browser skills get core
```

Load a specialized guide only when needed, for example
`agent-browser skills get electron` for Electron apps or
`agent-browser skills get dogfood` for exploratory QA. The CLI owns the detailed
command reference, workflows, and troubleshooting guidance, so they stay out of
the always-loaded agent prompt and remain matched to the installed version.
