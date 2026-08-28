---
name: git
description: Use whenever Git, branch, commit, pull request, PR, merge request, MR, worktree, or another Git operation is mentioned or needed.
---

# Git

## Branches

Whenever creating a feature branch:

- Always prefix feature branches with `simone/`, using `simone/<feature-branch-title>`. Use a specific kebab-case title. When unsure, prefer a longer descriptive title over a short generic one.

## Committing changes

When the user asks to commit:

- Inspect status, all diffs, untracked contents, and recent commits.
- Stage reviewed changes and create one commit with an accurate subject and body. Push only when requested.
- Return only the commit subject.

Never create a commit autonomously unless the user explicitly asks.

## Creating or updating pull requests / merge requests

When the user asks to create or update a PR/MR:

- Update the branch's existing PR/MR or create one.
- Use the full current diff and relevant user conversation context. After material changes, rewrite the title and description as a coherent whole instead of patching them with corrections or update notes.
- Make the title describe the dominant change. Avoid vague process wording and automation attribution.
- Lead the description with changed behavior and why it matters. Include implementation detail only when useful to reviewers. Use focused sections or before/after examples only for distinct changes or changed contracts.
- Omit file-by-file narration, commit logs, generic headings, template scaffolding, test plans, routine validation, unsupported issue references, and sensitive customer data.
- Link related PRs/MRs for cross-repository work.
- Return only the title and URL.

Do not create or update a PR/MR unless the user asks. You may refresh an existing PR/MR already known from the current context after material changes. Do not proactively check for one after every change.

## Creating worktrees

When the user asks to create a worktree:

- Place it beside the repository as `../<project-name>-<feature-branch-title>` using branch `simone/<feature-branch-title>`.
- Immediately after creating the worktree, ask the harness to request permission for `<generated-worktree-path>/*`. Do not continue first: external directories have no default access, so the agent will block.
