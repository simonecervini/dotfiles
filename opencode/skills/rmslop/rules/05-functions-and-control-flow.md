# Functions and control flow

## Related positional parameters

Symptom: a function accepts several related values whose order is easy to confuse.

```ts
// Wrong.
function createUser(name: string, role: Role, notify: boolean) {}

// Rewrite.
function createUser(options: { name: string; role: Role; notify: boolean }) {
  const { name, role, notify } = options
}
```

Keep one obvious input positional. Preserve positional arguments for established external APIs.

## Destructuring in the signature

Symptom: a function or component hides the complete boundary by destructuring its parameter immediately.

```tsx
// Wrong.
function UserCard({ name, role }: Props) {}

// Rewrite.
function UserCard(props: Props) {
  const { name, role } = props
}
```

## Trivial forwarding helper

Symptom: a one-use function only forwards arguments, constructs one value, or renames an existing operation.

```ts
// Wrong.
function createStore() {
  return new ConversationStore()
}

// Rewrite at the call site.
const store = new ConversationStore()
```

Keep wrappers that apply policy, translate contracts, instrument behavior, or represent a domain operation.

The same rule applies to a tiny helper with a few simple statements: inline it when it is called once, establishes no meaningful abstraction, and makes the reader jump away from its only caller.

## Redundant async wrapper

Symptom: an `async` function only returns another promise.

```ts
// Wrong.
async function loadUser() {
  return repository.loadUser()
}

// Rewrite.
function loadUser() {
  return repository.loadUser()
}
```

Keep `async` when awaiting is required for control flow, error translation, or cleanup.

## Deep rejection nesting

Symptom: each nested condition only rejects or exits, while the successful path drifts right.

```ts
// Wrong.
if (user) {
  if (user.isActive) {
    if (user.email) sendInvite(user.email)
  }
}

// Rewrite.
if (!user || !user.isActive || !user.email) return
sendInvite(user.email)
```

Keep nesting when branches are meaningful alternatives that are easier to compare together.

## Conditional empty-object spread

Symptom: an object uses `{}` as the false branch only to omit a property.

```ts
// Wrong.
const options = {
  ...(timeout !== undefined ? { timeout } : {}),
}

// Rewrite.
const options: RequestOptions = {}
if (timeout !== undefined) options.timeout = timeout
```

Preserve omission semantics. Do not replace omission with `timeout: undefined` when those differ.

## Expensive work before a settled result

Symptom: parsing, lookup, or I/O starts before a cheap guard that may return.

```ts
// Wrong.
const permissions = await loadPermissions(userId)
if (!resource) return notFound()

// Rewrite.
if (!resource) return notFound()
const permissions = await loadPermissions(userId)
```

Keep early work when starting it intentionally overlaps latency and all surviving paths consume or safely cancel it.

## Repeated linear lookup

Symptom: a loop or render repeatedly calls `.find()` or `.includes()` against the same collection.

```ts
// Wrong: O(users * teams).
const rows = users.map((user) => ({
  user,
  team: teams.find((team) => team.id === user.teamId),
}))

// Rewrite for a substantial collection.
const teamsById = new Map(teams.map((team) => [team.id, team]))
const rows = users.map((user) => ({ user, team: teamsById.get(user.teamId) }))
```

Use a `Set` for repeated membership checks. Keep direct `.find()` or `.includes()` for tiny collections or one lookup.

## Sorting only to find one extreme

Symptom: code sorts an entire collection only to read its minimum or maximum.

```ts
// Wrong.
const cheapest = products.toSorted((a, b) => a.price - b.price)[0]

// Rewrite.
const cheapest = products.reduce<Product | undefined>(
  (best, product) =>
    best === undefined || product.price < best.price ? product : best,
  undefined,
)
```

Keep sorting when the ordered collection is also used.

## Runtime imports an Effect service constructor

Symptom: non-test Effect code imports a project-local exported constructor such as `makeIssueService` directly.

```ts
// Wrong in runtime code.
import { makeIssueService } from "./issue-service"
const issues = makeIssueService(dependencies)

// Rewrite.
import { IssueService } from "./issue-service"
const program = Effect.gen(function* () {
  const issues = yield* IssueService
  return yield* issues.load()
})
```

Provide `IssueServiceLive` at the composition root, not at each caller. Focused `*.test.*` and `*.spec.*` files, package imports, and static branded constructors such as `WorkspaceName.make` are exempt.

## Falsy value mistaken for absence

Symptom: `value || fallback` replaces valid `0`, `false`, or empty-string values.

```ts
// Wrong when zero is valid.
const timeout = options.timeout || DEFAULT_TIMEOUT

// Rewrite.
const timeout = options.timeout ?? DEFAULT_TIMEOUT
```

Keep `||` when every falsy value should trigger the fallback.

## Truthiness filter drops valid values

Symptom: `.filter(Boolean)` removes valid `0`, `false`, or empty-string domain values, or fails to produce the intended TypeScript narrowing.

```ts
// Wrong when only nullish values are absent.
const values = input.filter(Boolean)

// Rewrite.
const values = input.filter((value): value is Item => value != null)
```
