---
name: rmslop
description: Use only when the user explicitly mentions `rmslop`. Review and clean code to remove common AI-generated code problems.
metadata:
  opencode/autoinvoke: false
---

# rmslop

Determine the review scope from the user's message, such as a group of files. If the scope is unclear, review the whole branch. Use a narrow scope only when the user requests it.

1. Read every file under `rules/` and check every `Symptom`.
2. Follow user requirements and project instructions before these rules.
3. Check the selected code and the related code that you need to understand it.
4. Apply a rewrite only when it preserves the required behavior.
5. Run the smallest relevant verification.
6. Return a short feedback note that names each material issue you fixed and explains why. Group related fixes. Omit file names, passed checks, unchanged rules, and implementation details. Do not limit the number of issues. If you make no changes, say `No rmslop issues found.`