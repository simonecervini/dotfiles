# Maintenance and diagnostics

## Comment restates or narrates code

Symptom: a comment repeats the next line, explains syntax, apologizes, or says `Now`, `Next`, or `Finally`.

```ts
// Wait before retrying.
await sleep(100)
```

Rewrite:

```ts
await sleep(100)
```

Also remove comments that are plausible alone but inconsistent with the file's normal comment density and style.

## Workaround comment lacks the reason

Symptom: a comment says only `Workaround`, `Hack`, or describes what the line does.

```ts
// Delay before reading the deployment.
await sleep(100)
```

Rewrite:

```ts
// The sandbox reports a deployment before its endpoint accepts traffic.
await sleep(100)
```

Include the external constraint and removal condition when known.

## Debug or verbose logging remains

Symptom: `console.log`, progress logs, success logs, or payload dumps were added for development or without an observability requirement.

```ts
// Wrong.
console.log("Loading user", userId)
const user = await loadUser(userId)
console.log("Loaded user", user)

// Rewrite.
const user = await loadUser(userId)
```

Keep logs already required by the project's observability policy or needed for an actionable operational failure.

## Sensitive data enters diagnostics

Symptom: logs include credentials, tokens, personal data, request bodies, or sensitive domain payloads.

Rewrite: remove the log or emit only a stable identifier and approved redacted metadata.

## Development residue remains

Symptom: temporary flags, commented-out code, unfinished TODOs, unused imports, or unused declarations remain after the implementation.

Rewrite: delete them. Keep tracked TODOs only when the repository has an explicit convention and the task cannot complete them.

## Package replaces existing capability

Symptom: a new dependency implements behavior already handled clearly by the language, platform, or an installed package.

Rewrite: use the existing capability. Keep the dependency only when it provides a concrete correctness, interoperability, or maintenance benefit.

## Decorative code text

Symptom: source code, comments, logs, errors, or test names contain emojis.

Rewrite: remove them. User-facing product copy is outside this rule when the product explicitly requires it.
