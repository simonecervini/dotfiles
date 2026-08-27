# Change scope and evidence

## Unrelated cleanup

Symptom: the diff reformats, renames, reorders imports, or modernizes code unrelated to the task.

Rewrite: revert that churn. Keep cleanup inside changed code and the smallest surrounding area required for correctness.

Exception: repository tooling reformatted the whole file and separating it safely is impractical.

## Local convention replaced by personal preference

Symptom: new code follows a different naming, file, import, or control-flow style than adjacent code without fixing a defect.

Rewrite: match the file. Apply this skill's preference only when the repository has no convention, the local pattern weakens correctness, or the user explicitly requested the change.

## Speculative compatibility

Symptom: code accepts a legacy input, alternate shape, option, fallback, or retry that no caller or requirement needs.

```ts
// Wrong: every caller already has UserId.
function loadUser(input: UserId | string) {
  const id = typeof input === "string" ? UserId.make(input) : input
  return repository.load(id)
}

// Rewrite.
function loadUser(id: UserId) {
  return repository.load(id)
}
```

Keep compatibility only for a shipped API, persisted data, external consumer, or explicit requirement.

## Dead path retained after the change

Symptom: an old branch, adapter, declaration, comment, or fallback is now unreachable or unused but remains "just in case."

Rewrite: delete it. Version control is the archive.

## One-use variable adds no meaning

Symptom: a local variable is read once and only renames a simple expression.

```ts
// Wrong.
const isReady = status === "ready"
return isReady ? renderReady() : null

// Rewrite.
return status === "ready" ? renderReady() : null
```

Keep the variable when it names a domain decision, narrows a type, avoids duplication, or makes a complex expression readable.
