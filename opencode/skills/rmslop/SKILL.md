---
name: rmslop
description: Use after code changes to remove AI code slop before the final response.
---

# rmslop

Review only code changed in the current task.

1. Check every `Symptom` in every file under `rules/`.
2. User requirements and project instructions override these rules.
3. Match changed code against each `Symptom`; apply its rewrite only when it preserves requested behavior.
4. Run the smallest relevant verification.
5. Return a compact feedback note naming each material issue fixed and why. Group related fixes; omit files, passed checks, unchanged rules, and implementation details. Do not cap the issue count. If nothing changed, say `No rmslop issues found.`

Do not delegate this review.
