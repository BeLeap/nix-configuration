---
name: agent-browser
description: >-
  Use Pi's agent-browser CLI to interact with live websites and web apps, such
  as navigating, clicking, filling forms, extracting page data, taking
  screenshots, or testing a browser flow. Not for ordinary web searches or
  reading local files.
---

# agent-browser

Use this skill for browser automation. The `agent-skills` recipe installs
`agent-browser` into the user's profile, so Pi and other profile shells can run
it directly.

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
