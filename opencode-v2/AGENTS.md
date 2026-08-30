# Critical Rules

- HARD RULE: ALWAYS use English for assistant responses, code comments, documentation, generated files, commit messages, branch names, PR/MR titles, and PR/MR descriptions. This applies regardless of the language used by the user, the repository, the prompt, or any command arguments. Do not switch to another language.
- HARD RULE: ALWAYS load and apply the "unslop" skill to user-facing communication and all prose writing, including documentation and generated files. Apply it to the final wording, not only when editing existing text.
- HARD RULE: ALWAYS load and apply the "git" skill whenever Git is mentioned or any Git operation is involved. NEVER proceed without it, even for a trivial command.
- In TypeScript, strongly prefer inferred types over explicit annotations. When unsure, infer more and annotate less. Add explicit types only at real boundaries, for tooling, or when inference is clearly harmful.

# Design

When you design, create, or modify a user interface, follow the design system already used by the project. For epilot projects, use Volt UI and find its current documentation and source in `~/Developer/epilot-codebase`, while in monorepos, use the `ui` package when available and always read its README and inspect its source before use. Prefer the components, patterns, variants, and design tokens that these systems provide. They cover most UI requirements and keep the product consistent.

Do not invent shadows, dimensions, colors, or other visual conventions when the design system provides a suitable option. Add custom styles only when an explicit UI requirement cannot be met with the available system. In that case, use its tokens and patterns, and make the smallest necessary change.
