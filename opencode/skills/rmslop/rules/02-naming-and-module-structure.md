# Naming and module structure

## Module declaration order

Symptom: a module is ordered by implementation dependency, so private callees appear before public callers, or values, components, hooks, and helpers are interleaved.

Apply these priorities in order:

1. Group: module values, components, then helpers. Put custom hooks before other helpers inside the helper group.
2. Visibility inside each group: exported declarations, then private declarations.
3. Abstraction inside each visibility block: entry points and callers before the lower-level declarations they use.

Group order wins over visibility. A private component appears before an exported helper. Visibility wins over abstraction. An exported lower-level component appears before a private higher-level component in the same group.

```tsx
// Wrong: implementation-first ordering hides the public operation.
function formatUserName(user: User) {
  return user.name.trim()
}

export function getUserLabel(user: User) {
  return formatUserName(user)
}

// Rewrite: caller before callee.
export function getUserLabel(user: User) {
  return formatUserName(user)
}

function formatUserName(user: User) {
  return user.name.trim()
}
```

A complete module follows the same precedence across groups:

```tsx
export const PAGE_SIZE = 20
const EMPTY_USERS: readonly User[] = []

export function UsersPage() {
  const users = useUsers()
  return <UserList users={users} />
}

export function UserList(props: { users: readonly User[] }) {
  const users = props.users.length > 0 ? props.users : EMPTY_USERS
  return users.map((user) => <UserRow key={user.id} user={user} />)
}

function UserRow(props: { user: User }) {
  return <div>{getUserLabel(props.user)}</div>
}

export function useUsers() {
  return normalizeUsers(useUsersQuery().data ?? EMPTY_USERS)
}

export function getUserLabel(user: User) {
  return formatUserName(user)
}

function normalizeUsers(users: readonly User[]) {
  return [...users].sort(compareUsers)
}

function formatUserName(user: User) {
  return user.name.trim()
}

function compareUsers(left: User, right: User) {
  return left.name.localeCompare(right.name)
}
```

Imports, directives, and required module setup stay before these groups. Break the ordering only when runtime initialization semantics require a declaration to exist earlier; do not reverse it merely to avoid calling a function declared later.

## Single-component filename mismatch

Symptom: `UserCard.tsx` contains one component named `ProfileTile`.

Rewrite: rename the file or component so they match the repository's casing convention.

Exception: framework-reserved route files and deliberate component-family modules.

## Module constant casing

Symptom: a module-level symbolic constant, such as a fixed timeout, limit, or protocol literal, uses local-variable casing. A `const` binding alone does not make a value a symbolic constant.

```ts
// Wrong.
const retryDelay = 500

// Rewrite.
const RETRY_DELAY = 500
```

Keep camelCase for module-level runtime objects whose identity, lifecycle, or internal state matters, including clients, pools, loggers, caches, and singleton instances.

```ts
const ssm = new SSMClient()
const db = createDatabaseClient()
```

Do not uppercase mutable module state, functions, components, or established exported APIs.

## Vague implementation name

Symptom: `data`, `item`, `result`, `handler`, `shape`, or `value` hides an available domain name.

```ts
// Wrong.
const result = await loadInvoice()
function handleItem(item: Item) {}

// Rewrite.
const invoice = await loadInvoice()
function archiveInvoice(invoice: Invoice) {}
```

Generic names are acceptable in genuinely generic, tiny scopes.

Rename every identifier containing `shape` to its owner or domain role, such as `UserInput`, `InvoiceFields`, or `bounds`; `shape` does not explain what the value represents.

## Type encoded in the name

Symptom: the identifier repeats information TypeScript already provides.

```ts
// Wrong.
const userData: User = loadUser()
const userArray: User[] = loadUsers()

// Rewrite.
const user = loadUser()
const users = loadUsers()
```

Keep a suffix when it carries domain meaning, such as `formData`, not merely a language type.

## Artificial section comments

Symptom: comments such as `// Hooks`, `// Handlers`, or decorative separators divide ordinary code.

Rewrite: remove the labels and use blank lines between meaningful phases. If a function needs many labels, simplify it or extract substantial work.

## No visual phases

Symptom: state, derived values, effects, handlers, and rendering are packed together, or every statement is separated by a blank line.

Rewrite: use one blank line between logical phases, not between individual statements.
