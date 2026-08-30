---
name: git
description: Use whenever Git, branch, commit, pull request, PR, merge request, MR, worktree, or another Git operation is mentioned or needed.
---

# Git

Only commit, push, or create/update a PR/MR when the user explicitly requests it. A request to create/update a PR/MR authorizes the required commit and push. Authorization applies only to that request and does not carry over to later changes.

## Branches

Whenever creating a feature branch:

- Always prefix feature branches with `simone/`, using `simone/<feature-branch-title>`. Use a specific kebab-case title. When unsure, prefer a longer descriptive title over a short generic one.

## Committing changes

When the user asks to commit:

- Inspect status, all diffs, untracked contents, and recent commits.
- Create one commit with an accurate, single-line message based on the context gathered during the task. Push only when requested.

## Creating or updating pull requests / merge requests

When the user asks to create or update a PR/MR:

- Update the branch's existing PR/MR or create one.
- Use the full current diff and relevant conversation context to understand the change, but keep the description concise and include only what human reviewers need. After material changes, rewrite the title and description as a coherent whole instead of patching them with corrections or update notes.
- Make the title describe the dominant change. Avoid vague process wording and automation attribution.
- Lead the description with changed behavior and why it matters. Include implementation detail only when useful to reviewers. Use sections or before/after examples only when they make distinct changes or changed contracts easier to understand; otherwise, use plain paragraphs.
- Omit file-by-file narration, commit logs, generic headings, template scaffolding, test plans, routine validation, unsupported issue references, and sensitive customer data.
- Link related PRs/MRs for cross-repository work.
- When a PR/MR is created or updated, include its title and URL in the final response.

## Creating worktrees

When the user asks to create a worktree:

- Place it beside the repository as `../<project-name>-<feature-branch-title>` using branch `simone/<feature-branch-title>`.
- Immediately after creating the worktree, use the OpenCode API to move the current session to the new worktree directory. Do not continue first.
