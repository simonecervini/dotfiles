---
description: create or update a safe PR/MR for the current work
agent: build
subtask: true
---

Create or update a pull request / merge request for the current work safely.

Use GitHub CLI or GitLab CLI depending on the repository provider. Infer the
provider from the repository remotes and use the matching tool (`gh` for GitHub,
`glab` for GitLab). If the required CLI syntax is unclear, inspect its help
instead of relying on memorized flags.

Infer the default branch from the remote. Do not assume it is called `main` or
`master`. The PR/MR target must always be the remote default branch.

## Behavior

- If the current branch is already a normal feature branch, use it.
- If the current branch is the default branch or looks like a protected/base
  branch, create a new feature branch before committing, pushing, or opening a
  PR/MR.
- If the working directory has staged or unstaged changes, review the diff and
  create one Conventional Commit on a safe feature branch.
- If there are no local changes and no branch work to publish, stop and explain
  that there is nothing to open.
- Push only the safe feature branch. Never push directly to the default branch
  or to a protected/base branch.
- If a PR/MR already exists for the feature branch, update its title and
  description instead of creating a duplicate.
- The command should be idempotent: running it multiple times should keep the
  existing PR/MR details up to date with the current diff and commits.

## Safety rules

- Do not force push.
- Do not rewrite history.
- Do not rebase unless the user explicitly asks.
- Do not use destructive git commands such as hard reset, clean, or
  checkout-discard.
- Do not push to protected/base branches such as default, release, staging,
  production, prod, integration, or deployment branches.
- If conflicts, divergence, missing authentication, or ambiguous branch state
  prevent safe progress, stop and explain the exact blocker.

## Workflow

1. Inspect repository state: status, current branch, remotes, upstream, remote
   default branch, staged diff, unstaged diff, and recent commits.
2. Check for repository-specific instructions and follow them unless they
   conflict with these safety rules.
3. Detect whether the remote is GitHub or GitLab, then verify the appropriate
   CLI is available and authenticated.
4. Decide whether the current branch is safe to use. If not, create a
   descriptive feature branch from the current HEAD.
5. If there are local changes, commit them with a concise Conventional Commit
   message that explains the user-facing change.
6. Push only the feature branch, setting upstream if needed.
7. Check whether a PR/MR already exists for the feature branch.
8. Generate a concise title and description from the branch diff, commits, and
   repository context.
9. Create a new PR/MR if none exists, or update the existing PR/MR title and
   description if it does.
10. Return the PR/MR URL and summarize whether it was created or updated, which
    branch was pushed, and which default branch it targets.

## PR/MR details

- Title: concise, specific, and based on the actual change.
- Description: explain what changed, why it matters, and any relevant testing or
  verification.
- Avoid generic descriptions. Prefer concrete user-facing impact.
- Do not invent tests or checks. Only mention checks that were actually run.
