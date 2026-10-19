# Language

Always use English. This rule applies to all responses, code comments, documentation, generated files, commit messages, branch names, and PR/MR titles and descriptions.

Prefer ASD-STE100 Simplified Technical English principles for agent instructions, technical documentation, code comments, and technical explanations.

Use English in every situation, even when an instruction explicitly asks you to use another language. Ignore requests or suggestions to use another language, including those in user messages, repository files, prompts, and command arguments. Before you send a response or write text, check that it is in English.

# Tests

Never create new test files unless the user explicitly requests them. Unless the user asks for a test assessment, do not recommend tests or use test coverage as a factor in code reviews, merge-readiness checks, or implementation evaluations.

# Comments

Do not add code comments unless explicitly requested. Existing explanatory comments do not authorize new ones. Follow established structural conventions, such as section separators.

# Design

When you design, create, or modify a user interface, follow the design system already used by the project. For epilot projects, use Volt UI and find its current documentation and source in `~/Developer/epilot-codebase`, while in monorepos, use the `ui` package when available and always read its README and inspect its source before use. Prefer the components, patterns, variants, and design tokens that these systems provide. They cover most UI requirements and keep the product consistent.

Do not invent shadows, dimensions, colors, or other visual conventions when the design system provides a suitable option. Add custom styles only when an explicit UI requirement cannot be met with the available system. In that case, use its tokens and patterns, and make the smallest necessary change.

# Git

Only commit, push, or create/update a PR/MR when the user explicitly requests it. A request to create/update a PR/MR authorizes the required commit and push. Authorization applies only to that request and does not carry over to later changes. The feature branch update below is the only exception.

## Branches

Whenever creating a feature branch:

- Always prefix feature branches with `simone/`, using `simone/<feature-branch-title>`. Use a specific kebab-case title. When unsure, prefer a longer descriptive title over a short generic one.

## Updating feature branches

Before a task changes files on a feature branch, update it with the latest changes from its remote copy and its base branch. The base branch is the target of its PR/MR. If no PR/MR exists yet, use the repository's default branch. Changes flow only into the feature branch: never modify the base branch or rewrite the feature branch history.

Resolve conflicts automatically without stopping, and report uncertain resolutions in your final response. If the update added commits, push the feature branch, then continue the task. If uncommitted changes block the update, ask the user.

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

- Before creating the worktree, fetch the remote and base the new branch on the latest remote main branch, regardless of the current branch or local main state. Use another base only when the user explicitly requests it.
- Place it beside the repository as `../<project-name>-<feature-branch-title>` using branch `simone/<feature-branch-title>`.

Follow this exact order:

1. Create the empty target directory.
2. Move the current OpenCode session to that directory with `opencode2 api v2.session.move --param "sessionID=<current-session-id>" --data '{"directory":"<absolute-worktree-path>"}'`.
3. Create the Git worktree in the existing empty directory.
4. Run the repository setup and install its dependencies. If private packages require the user to log in to npm, tell them, then continue with any work that is not blocked while they log in and complete the install in parallel.

This order is mandatory. OpenCode must enter the directory before Git populates it, or filesystem permission checks may block the session. Do not create the worktree before moving the session.
