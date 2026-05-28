---
description: commit and push current git changes
agent: build
subtask: true
---

Create one Conventional Commit from the current repository changes, then push it.

Keep this fast: inspect the full git change set, write a good commit message, commit everything, and push.

Steps:
- Inspect changes with `git status --short`, `git diff --cached`, `git diff`, and `git ls-files --others --exclude-standard`.
- If there are untracked files, inspect their contents too, because they will be included in the commit.
- Write a Conventional Commit subject plus a short body explaining the meaningful change for future agents.
- Stage everything, commit with subject and body, then push.
- If there are conflicts, no changes, suspicious unrelated changes, or push fails, stop and report the blocker.
- Final output: one line with commit hash, subject, and push result.
