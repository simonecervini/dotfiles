---
description: split current work into focused PRs/MRs
agent: build
---

Split the current work into one or more focused pull requests / merge requests.

<user_input>
$ARGUMENTS
</user_input>

`user_input` is required. If it is empty, stop and ask what to extract.

Use `gh` for GitHub and `glab` for GitLab. Infer the provider from remotes. Infer
the remote default branch and target every extracted PR/MR to it, not to the
branch being split.

The user may request one split or many, including explicit counts like "split
this into 4 PRs". If the scope is clear, proceed autonomously. Determine from
`user_input` whether extracted changes must be moved (removed from the source
branch) or copied (kept there too). If this is not explicit or unmistakable,
ask one short question before changing branches or files. Also ask only when a
scope is genuinely ambiguous or unsafe to separate.

Workflow:

1. Inspect status, current branch, remotes, upstream, default branch, diffs,
   untracked files, recent commits, and any existing PR/MR.
2. Parse `user_input` into one or more extraction scopes.
3. For each scope, create a focused branch from the remote default branch, apply
   only that scope, commit it, push it, and create/update its PR/MR. Keep branch
   names, commit messages, PR/MR text, summaries, and final response in English
   for consistency across repositories and tooling.
4. Preserve unrelated work on the source branch. Keep or remove each extracted
   scope there according to the decision above; never assume removal.
5. Finish with an extracted branch checked out, never the source branch. For
   multiple scopes, use the last created branch unless the user specified one.
6. Return all PR/MR URLs, what each contains, and what remains outside them.

Safety:

- Do not force push, rewrite history, rebase, hard reset, clean, discard work, or
  push to protected/base branches.
- If conflicts, divergence, missing authentication, unsafe separation, or
  ambiguous branch state prevents safe progress, stop and explain the blocker.

IMPORTANT: THIS COMMAND AUTHORIZES BRANCH CREATION, COMMITS, PUSHES, AND PR/MR CREATION OR UPDATES ONLY FOR THIS EXTRACTION OPERATION. IT DOES NOT AUTHORIZE FUTURE COMMITS, PUSHES, BRANCH CHANGES, OR PR/MR UPDATES AFTER THIS COMMAND FINISHES. IF THE USER ASKS FOR MORE CODE CHANGES LATER, MAKE THEM LOCALLY AND STOP UNLESS THE USER EXPLICITLY ASKS TO COMMIT, PUSH, OR UPDATE THE PR/MR AGAIN.
