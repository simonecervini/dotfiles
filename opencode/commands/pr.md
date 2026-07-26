---
description: create or update a PR/MR for the current work
agent: build
---

Create or update a pull request / merge request for the current work.

<user_context>
$ARGUMENTS
</user_context>

Use `gh` for GitHub and `glab` for GitLab. Infer the provider from remotes. If
CLI syntax is unclear, inspect help first.

Do not assume the default branch name. Infer the remote default branch and use it
as the PR/MR target.

Workflow:

1. Inspect status, current branch, remotes, upstream, default branch, diffs,
   untracked files, and recent commits.
2. If current branch is a base/protected branch, create a safe feature branch.
3. If there are local changes, review them and create one Conventional Commit.
4. Push only the feature branch, setting upstream if needed.
5. If a PR/MR already exists for the branch, update title and description.
6. Otherwise create a new PR/MR.
7. Generate title and description from the actual diff, commits, repository
   context, and optional `user_context`. Keep branch names, commit messages,
   PR/MR text, summaries, and final response in English for consistency across
   repositories and tooling. Do not invent checks or changes.
8. Return the PR/MR URL and a short summary.

Safety:

- Do not force push, rewrite history, rebase, hard reset, clean, discard work, or
  push to protected/base branches.
- If conflicts, divergence, missing authentication, or ambiguous branch state
  prevents safe progress, stop and explain the blocker.

IMPORTANT: THIS COMMAND AUTHORIZES COMMITS, PUSHES, AND PR/MR CREATION OR UPDATES ONLY FOR THIS PR/MR OPERATION. IT DOES NOT AUTHORIZE FUTURE COMMITS, PUSHES, BRANCH CHANGES, OR PR/MR UPDATES AFTER THIS COMMAND FINISHES. IF THE USER ASKS FOR MORE CODE CHANGES LATER, MAKE THEM LOCALLY AND STOP UNLESS THE USER EXPLICITLY ASKS TO COMMIT, PUSH, OR UPDATE THE PR/MR AGAIN.
