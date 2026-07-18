# Review AGENTS against work-retrospective

Reviewed `/Users/beleap/Downloads/SKILL.md` against `files/AGENTS.md` without modifying the shared instructions.

The initial review interpreted the request as governing AGENTS.md changes. The user clarified that the comparison concerns the existing journaling practice itself.

Recommended enhancing the `# Journal` instructions with a lightweight retrospective/handoff structure for non-trivial work: outcome and changes, validation (including failures), unexpected findings or reusable lessons, and unresolved follow-ups. Empty retrospective categories should be omitted rather than filled artificially. Also recommended explicitly consulting relevant prior entries before related work. The downloaded skill's full Linear routing and interactive approval ceremony remain too workflow-specific for this global journal policy.

After user approval, enhanced `files/AGENTS.md` accordingly. The journal now requires a lightweight, optional retrospective structure and consultation of relevant prior entries while retaining its existing VCS and operational-context guidance.

Validation: the default `jj diff -- files/AGENTS.md` failed because its configured external diff could not create a temporary directory in the sandbox. Retried with `jj diff --git -- files/AGENTS.md`, reviewed the focused diff successfully, and confirmed `jj status` reports only this journal entry and `files/AGENTS.md`. This documentation-only change requires no automated checks.
