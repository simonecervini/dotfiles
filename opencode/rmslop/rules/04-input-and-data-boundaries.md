# Input and data boundaries

## Untrusted data trusted by assertion

Symptom: API data, user input, JSON, storage, or message payloads are annotated or cast directly to a domain type.

```ts
// Wrong.
const user = (await response.json()) as User

// Rewrite.
const user = UserSchema.parse(await response.json())
```

Use the project's existing schema library. Do not introduce a second validation system without a requirement.

## Runtime shape check inside business logic

Symptom: even one `typeof`, `in`, `Reflect.get`, or property-presence check narrows unparsed input after it entered business logic.

```ts
// Wrong.
if (typeof input === "object" && input !== null && "id" in input) {
  return loadUser(input.id as string)
}

// Rewrite.
const request = UserRequestSchema.parse(input)
return loadUser(request.id)
```

In a schema-free project, a dedicated type predicate may centralize primitive checks. Do not scatter them across business logic.

## Unknown parameter inside ordinary code

Symptom: an implementation, callback type, method, constructor, declaration, rest parameter, defaulted parameter, or destructured parameter accepts `unknown` after the I/O edge.

```ts
// Wrong.
function saveUser(input: unknown) {
  const user = UserSchema.parse(input)
}

// Rewrite.
const user = UserSchema.parse(request.body)
saveUser(user)
```

An error parameter named `cause` may remain unknown when the project's error model uses that convention.

## Broad object parameter

Symptom: any function-type position accepts `object`, `{}`, or a union or alias containing them instead of the owner contract.

```ts
// Wrong.
function save(value: object) {}

// Rewrite.
function save(user: User) {}
```

Generic constraints such as `T extends object` are acceptable in genuinely generic infrastructure.

## Reflect hides typed access

Symptom: ordinary code uses `Reflect.get` or `Reflect.apply` to bypass known property or function types.

```ts
// Wrong.
const name = Reflect.get(user, "name")
const result = Reflect.apply(operation, owner, args)

// Rewrite.
const name = user.name
interface Operation {
  invoke(options: { owner: Owner; args: readonly Argument[] }): Result
}
const result = operation.invoke({ owner, args })
```

Convert genuinely dynamic dispatch to a typed named interface that preserves the receiver and variable arguments. For a known function signature, call it directly. Validate dynamic keys before access.

## Request data stored in module state

Symptom: server-rendered code writes the current user, request, locale, or token to a module variable.

```tsx
// Wrong: concurrent requests overwrite each other.
let currentUser: User | null = null

export async function Page() {
  currentUser = await auth()
  return <Dashboard />
}

// Rewrite.
export async function Page() {
  const user = await auth()
  return <Dashboard user={user} />
}
```

Immutable configuration and deliberately keyed process-wide caches are separate cases.

## Oversized server-to-client payload

Symptom: a client component receives a whole domain object but reads one or two fields.

```tsx
// Wrong.
return <UserName user={user} />

// Rewrite.
return <UserName name={user.name} />
```

Pass the full object only when the client genuinely consumes its complete contract.
