# Critical Rules

- HARD RULE: ALWAYS use English for assistant responses, code comments, documentation, generated files, commit messages, branch names, PR/MR titles, and PR/MR descriptions. This applies regardless of the language used by the user, the repository, the prompt, or any command arguments. Do not switch to another language.
- HARD RULE: when creating a feature branch for the user's work, use `simone/<long-kebab-case-description>`
- In TypeScript, strongly prefer inferred types over explicit annotations. When unsure, infer more and annotate less. Add explicit types only at real boundaries, for tooling, or when inference is clearly harmful.
- When logic becomes complex or non-trivial, consider a fitting design pattern before adding ad-hoc structure. Prefer simple, natural uses of common patterns such as Factory, Builder, Adapter, Decorator, Proxy, Strategy, Iterator, etc. Do not force patterns into simple code.
