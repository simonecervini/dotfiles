---
description: rename the current commit and push it
agent: build
subtask: true
---

Rename the current commit, then push it.

The commit already exists. Do not stage files, do not create a new commit, and ignore working tree or index changes.

Steps:
- Inspect only the current commit with `git show --stat --patch --find-renames HEAD` and `git show --name-status --find-renames HEAD`.
- Write a high-quality Conventional Commit subject plus a short body explaining the meaningful change for future agents.
- Rename the current commit by amending only the commit message with `git commit --amend --only`.
- Push with `git push -u origin HEAD`.
- If amend or push fails, stop and report the blocker.
- Final output: one line with commit hash, subject, and push result.
