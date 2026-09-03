---
description: Resume a branch in its worktree and sync it with the default branch
agent: build
subagent: false
---

Resume work on Git branch `$1`.

Load the Git skill. Reuse the branch's worktree if it exists, otherwise create it. Move this OpenCode session into that worktree.

Bring the feature branch up to date with its remote, then merge the latest remote default branch into it. Resolve conflicts when the intended result is clear and push the updated feature branch.

Preserve uncommitted work. Do not rebase, rewrite history, force push, or change the pull request. Stop and explain the blocker when proceeding safely requires a user decision.

This command authorizes the Git changes and push required above only. Finish with a short status summary and the worktree path.
