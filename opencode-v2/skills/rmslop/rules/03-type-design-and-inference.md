# Type design and inference

## Redundant annotation

Symptom: a local type repeats what the initializer already proves.

```ts
// Wrong.
const count: number = 0
const user: User = await loadUser()

// Rewrite.
const count = 0
const user = await loadUser()
```

Annotate public boundaries, recursive definitions, tooling requirements, or cases where inference is unclear or harmful.

## Object literal implements a contract

Symptom: an object literal is stored before being passed to a typed consumer, so structural typing can allow extra properties and mutable fields can widen.

```ts
type CreateUserInput = {
  name: string
  active: boolean
}

// Wrong: the later call is not the strongest check for this literal.
const user = {
  name: "Ada",
  active: true,
  debug: true,
}
createUser(user)

// Rewrite: validate the literal while preserving its precise inferred type.
const user = {
  name: "Ada",
  active: true,
} satisfies CreateUserInput
createUser(user)
```

Prefer `satisfies Contract` when a local literal must conform to a known contract. Use `: Contract` when the variable itself should expose exactly that declared type or needs contextual widening for later mutation.

## Known value widened

Symptom: a populated literal, property initializer, assignment, return, or assertion loses known keys or literals through `unknown`, `object`, an anonymous object, or a broad dictionary target.

```ts
// Wrong: `start` is lost as a known key.
const handlers: Record<string, Handler> = {
  start: startHandler,
}

// Rewrite.
const handlers = {
  start: startHandler,
} satisfies Record<string, Handler>
```

A broad annotation is acceptable for an empty mutable accumulator because it has no known keys to preserve.

## Widen then assert back

Symptom: a precise value becomes `unknown`, `object`, or a broad dictionary and is later cast to its original type.

```ts
// Wrong.
const loaded: User = loadUser()
const stored: unknown = loaded
const user = stored as User

// Rewrite.
const user = loadUser()
```

If the original value is untrusted, parse it once instead of preserving a false precise type.

## Trivial or unknown-hiding alias

Symptom: a type only renames a primitive, `unknown`, or an existing contract.

```ts
// Wrong.
type ExternalValue = unknown
type UserName = string

// Rewrite unknown input at the I/O boundary.
const externalValue = ExternalValueSchema.parse(input)

// Rewrite a plain string alias with inference.
const userName = user.name
```

Keep an alias or brand when it enforces a real invariant or establishes stable public vocabulary.

## Unsafe dictionary value

Symptom: an index signature, `Record`, mapped type, union, alias, or utility wrapper stores `unknown`, `any`, `object`, `{}`, or an effectively empty interface as its direct value.

```ts
// Wrong.
type Metadata = Record<string, unknown>

// Rewrite: define the values this owner actually accepts.
const MetadataValueSchema = z.union([z.string(), z.number(), z.boolean()])
const MetadataSchema = z.record(z.string(), MetadataValueSchema)
type Metadata = z.infer<typeof MetadataSchema>
const metadata = MetadataSchema.parse(externalPayload)
```

Defining the schema-derived type is not validation; parse external payloads before insertion.

Do not flag `Map`, `ReadonlyMap`, or nested unknown payloads such as `Record<string, { payload: unknown }>` automatically; their direct value has a known owner type.

## Unknown return contract

Symptom: a function, callback, method, constructor, declaration, alias, `Promise`, or `PromiseLike` explicitly returns `unknown` or a union containing it.

```ts
// Wrong.
function loadUser(): unknown {
  return JSON.parse(storage.get("user"))
}

// Rewrite.
function loadUser() {
  return UserSchema.parse(JSON.parse(storage.get("user")))
}
```

Generic pass-through utilities may preserve an unknown generic when they do not claim to understand it.

## Assertion fabricates evidence

Symptom: `as any`, a non-null assertion, `as SomeType`, angle-bracket syntax such as `<User>value`, or a chain such as `value as unknown as User` suppresses an error.

```ts
// Wrong.
const user = input as unknown as User

// Rewrite.
const user = UserSchema.parse(input)
```

Fix the source type, narrow through a proven discriminant, or parse the boundary. Never chain assertions.

`as const` is allowed because it preserves evidence.

Highly abstract generic infrastructure may retain the minimum `as any` only when TypeScript cannot express an already-proven invariant; document that invariant.

## Necessary assertion lacks proof

Symptom: a non-const assertion remains without a specific `SAFETY:` comment immediately before the assertion or its containing statement. Trailing and vaguely nearby comments do not count.

```ts
// Wrong.
const userId = value as UserId

// Rewrite.
const parsed = parseIdentifier(value)
// SAFETY: parseIdentifier validated the UserId syntax before branding.
const userId = parsed as UserId
```

A generic comment such as `// This cast is safe` is not proof. If the invariant cannot be named, remove the assertion.
