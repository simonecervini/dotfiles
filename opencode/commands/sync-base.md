---
description: Merge the latest default branch into the current feature branch safely
agent: build
subtask: true
---

Merge the latest remote default branch into the current branch.

Infer the repository default branch from the remote. Do not assume it is called `main` or `master`.

## Before changing anything

- Check whether the repository has project-specific Git or merge instructions, such as `PROJECT.md`, `AGENTS.md`, `CLAUDE.md`, or similar, and follow them unless they conflict with these safety rules.
- Stop immediately if the current branch is the detected default branch.
- Stop immediately if the current branch looks like a protected/base branch, such as a release, staging, production, integration, or deployment branch.
- If the working directory is not clean, pause and ask the user what to do before continuing. Do not pull, merge, stash, commit, or discard changes without explicit approval.

## Safety rules

- Do not rebase.
- Do not force push.
- Do not rewrite history.
- Do not use destructive git commands such as hard reset, clean, or checkout-discard.
- Before merging the default branch, pull the latest changes for the current branch from its upstream branch. Without this step, the local branch may not include remote updates.
- If pulling the current branch is blocked by local changes, divergence, or conflicts, stop and ask the user how to proceed instead of choosing a strategy automatically.
- Make sure the remote default branch is up to date before merging it.
- Prefer creating a temporary recovery branch before attempting the merge, especially if conflicts are likely.

## Conflict handling

- If conflicts occur, resolve them automatically.
- Inspect the feature branch diff, the incoming default-branch changes, surrounding code, tests, and available repository context before editing.
- Preserve the intent of the current feature branch unless the default branch clearly supersedes it.
- Prefer minimal, coherent conflict resolutions.
- Do not resolve conflicts by blindly choosing one side.
- If a conflict cannot be resolved with high confidence, stop and explain the exact uncertainty.

## Final output

- State which default branch was detected and merged.
- State whether a recovery branch was created.
- State whether conflicts occurred and how they were resolved.
- State which checks were run and their result.
