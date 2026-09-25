# Critical Rules

- HARD RULE: ALWAYS use English for assistant responses, code comments, documentation, generated files, commit messages, branch names, PR/MR titles, and PR/MR descriptions. This applies regardless of the language used by the user, the repository, the prompt, or any command arguments. Do not switch to another language.

# Tests

Never create new test files unless the user explicitly requests them. Unless the user asks for a test assessment, do not recommend tests or use test coverage as a factor in code reviews, merge-readiness checks, or implementation evaluations.

# Design

When you design, create, or modify a user interface, follow the design system already used by the project. For epilot projects, use Volt UI and find its current documentation and source in `~/Developer/epilot-codebase`, while in monorepos, use the `ui` package when available and always read its README and inspect its source before use. Prefer the components, patterns, variants, and design tokens that these systems provide. They cover most UI requirements and keep the product consistent.

Do not invent shadows, dimensions, colors, or other visual conventions when the design system provides a suitable option. Add custom styles only when an explicit UI requirement cannot be met with the available system. In that case, use its tokens and patterns, and make the smallest necessary change.

# Git

Only commit, push, or create/update a PR/MR when the user explicitly requests it. A request to create/update a PR/MR authorizes the required commit and push. Authorization applies only to that request and does not carry over to later changes.

## Branches

Whenever creating a feature branch manually:

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
