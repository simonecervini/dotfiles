# Critical Rules

- HARD RULE: ALWAYS use English for assistant responses, code comments, documentation, generated files, commit messages, branch names, PR/MR titles, and PR/MR descriptions. This applies regardless of the language used by the user, the repository, the prompt, or any command arguments. Do not switch to another language.
- HARD RULE: when creating a feature branch for the user's work, use `simone/<long-kebab-case-description>`
- Always apply the "unslop" skill
- In TypeScript, strongly prefer inferred types over explicit annotations. When unsure, infer more and annotate less. Add explicit types only at real boundaries, for tooling, or when inference is clearly harmful.
