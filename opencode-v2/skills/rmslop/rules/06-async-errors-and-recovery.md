# Async, errors, and recovery

## Independent work awaited serially

Symptom: async operations with no data or ordering dependency are awaited one after another.

```ts
// Wrong.
const user = await loadUser()
const teams = await loadTeams()
const flags = await loadFlags()

// Rewrite.
const [user, teams, flags] = await Promise.all([
  loadUser(),
  loadTeams(),
  loadFlags(),
])
```

Keep sequence for dependencies, transactions, rate limits, required ordering, shared mutation, or failure semantics that must prevent later work from starting.

The same rule applies to independent loops:

```ts
// Wrong.
for (const user of users) {
  await refreshUser(user)
}

// Rewrite.
await Promise.all(users.map((user) => refreshUser(user)))
```

Do not parallelize when the operation is intentionally sequential or concurrency must be bounded.

## Async collection work is not observed

Symptom: `forEach(async ...)` discards promises, or an async `.map()` is treated as resolved values.

```ts
// Wrong.
users.forEach(async (user) => refreshUser(user))
const loadedUsers = ids.map(async (id) => loadUser(id))

// Rewrite.
await Promise.all(users.map((user) => refreshUser(user)))
const loadedUsers = await Promise.all(ids.map((id) => loadUser(id)))
```

Use `for...of` with `await` when order or bounded execution is required. Return `Promise[]` only when that is the explicit contract.

## Await happens outside its only branch

Symptom: every path waits for data used by only one branch.

```ts
// Wrong.
const profile = await loadProfile()
if (skipProfile) return summary
return renderProfile(profile)

// Rewrite.
if (skipProfile) return summary
const profile = await loadProfile()
return renderProfile(profile)
```

Start work earlier when all paths need it or safe overlap reduces a real waterfall.

## Partial dependencies form a global waterfall

Symptom: all parent requests finish before any child request starts, although each child depends only on its own parent.

```ts
// Wrong.
const issues = await Promise.all(ids.map(loadIssue))
const owners = await Promise.all(issues.map((issue) => loadOwner(issue.ownerId)))

// Rewrite.
const owners = await Promise.all(
  ids.map((id) => loadIssue(id).then((issue) => loadOwner(issue.ownerId))),
)
```

Keep batching or bounded concurrency when the backend or collection size requires it.

## Independent work starts after an avoidable dependency

Symptom: one request waits for authentication or another result even though only a later request needs that result.

```ts
// Wrong: config waits for auth without depending on it.
const session = await auth()
const config = await loadConfig()
const data = await loadData(session.user.id)

// Rewrite.
const sessionPromise = auth()
const configPromise = loadConfig()
const session = await sessionPromise
const [config, data] = await Promise.all([
  configPromise,
  loadData(session.user.id),
])
```

## Catch adds no behavior

Symptom: a catch is empty or only throws the same error.

```ts
// Wrong.
try {
  return await loadUser()
} catch (error) {
  throw error
}

// Rewrite.
return loadUser()
```

Catch only to recover, translate into useful domain context, or perform required cleanup.

## Error translation erases the cause

Symptom: a new domain error replaces the diagnostic chain or only changes wording.

```ts
// Wrong.
catch {
  throw new Error("Could not load user")
}

// Rewrite.
catch (cause) {
  throw new UserLoadError({ userId, cause })
}
```

If no actionable context or contract change is added, let the original error propagate.

## Defensive recovery without a failure mode

Symptom: trusted code paths gain retries, catches, null defaults, optional chaining, or fallbacks for states excluded by their contract.

Rewrite: remove the branch and honor the contract. Add recovery only for an untrusted boundary, documented failure mode, or explicit requirement.
