# React rendering and state

## Derived value stored in state

Symptom: state duplicates a value fully determined by props or other state.

```tsx
// Wrong.
const [fullName, setFullName] = useState("")
useEffect(() => setFullName(`${firstName} ${lastName}`), [firstName, lastName])

// Rewrite.
const fullName = `${firstName} ${lastName}`
```

Keep only the minimum source of truth in state.

For expensive pure derivation, remove the state and effect first, then use `useMemo(() => derive(input), [input])` only when the work is substantial. Memoization is an optimization, not semantic storage.

## Selected object duplicated in state

Symptom: state stores an object from a collection and needs synchronization when the collection changes.

```tsx
// Wrong.
const [selectedUser, setSelectedUser] = useState<User | null>(null)

// Rewrite.
const [selectedUserId, setSelectedUserId] = useState<UserId | null>(null)
const selectedUser = users.find((user) => user.id === selectedUserId) ?? null
```

## Trivial memoization

Symptom: `useMemo` wraps a cheap primitive expression, property access, or small calculation.

```tsx
// Wrong.
const isLoading = useMemo(
  () => user.isLoading || notifications.isLoading,
  [user.isLoading, notifications.isLoading],
)

// Rewrite.
const isLoading = user.isLoading || notifications.isLoading
```

Use `useMemo` only to skip substantial pure recomputation or preserve identity across a real memoization boundary. Do not rely on it for correctness, persistence, or one-time execution. Follow the project's React Compiler policy.

## Callback memoized by default

Symptom: every local handler uses `useCallback` without a memoized consumer or hook contract requiring stable identity.

Rewrite: use an ordinary function. Add `useCallback` only for a real identity boundary or measured render problem.

## Substantial derived render pipeline is scattered

Symptom: filtering, grouping, sorting, or mapping a substantial collection is repeated across JSX or stored through an effect to avoid recomputation.

```tsx
// Rewrite when the work is substantial and pure.
const visibleRows = useMemo(() => {
  const filtered = rows.filter((row) => row.category === category)
  return filtered.toSorted((left, right) =>
    sortOrder === "asc" ? left.rank - right.rank : right.rank - left.rank,
  )
}, [rows, category, sortOrder])
```

Keep cheap transformations direct. Split memoized stages only when they have genuinely different dependencies and avoiding repeated work matters.

## Render helper hides JSX

Symptom: `renderHeader()` or `renderRows()` is called once only to move JSX out of sight.

Rewrite: keep simple JSX inline. Extract a module-level component when the UI has its own responsibility, state, or reusable boundary.

## Component defined during render

Symptom: a component function is declared inside another component and rendered as `<Row />`.

```tsx
// Wrong: Row remounts on every Parent render.
function Parent(props: Props) {
  function Row() {
    return <div>{props.name}</div>
  }
  return <Row />
}

// Rewrite.
function Row(props: { name: string }) {
  return <div>{props.name}</div>
}

function Parent(props: Props) {
  return <Row name={props.name} />
}
```

Move it to module scope and pass props.

## State update reads previous state directly

Symptom: the next value is computed from a captured state value, especially in async callbacks or subscriptions.

```tsx
// Wrong.
setItems([...items, newItem])

// Rewrite.
setItems((current) => [...current, newItem])
```

Direct setters are correct when the next value depends only on an argument, prop, or constant.

## Expensive initial snapshot runs every render

Symptom: expensive computation for an intentionally fixed initial snapshot executes during every render even though React uses only the first result.

```tsx
// Wrong.
const [initialIndex] = useState(buildIndex(initialItems))

// Rewrite.
const [initialIndex] = useState(() => buildIndex(initialItems))
```

If the value must follow changing props, it is derived data: compute it during render or use `useMemo`. Do not use lazy initialization for cheap primitives and literals. Guard browser storage access in SSR-capable components.

## Numeric condition leaks into JSX

Symptom: `{count && <Badge />}` can render `0` or `NaN`.

```tsx
// Wrong.
return count && <Badge count={count} />

// Rewrite.
return count > 0 ? <Badge count={count} /> : null
```

Boolean conditions may use `&&` when that matches local style.

## Props or state mutated during render

Symptom: render calls `sort`, `reverse`, `splice`, or writes into an object received from props or state.

```tsx
// Wrong.
const sorted = props.items.sort(compareItems)

// Rewrite.
const sorted = [...props.items].sort(compareItems)
```

Use `toSorted` when the repository's runtime target supports it. Create new references along every changed path.

## Unstable or meaningless key

Symptom: list keys use array indexes, random values, or values generated during render when stable domain IDs exist. Local row state then follows positions instead of records after insertion or reordering.

```tsx
// Wrong.
{users.map((user, index) => <UserRow key={index} user={user} />)}

// Rewrite.
{users.map((user) => <UserRow key={user.id} user={user} />)}
```

Use a deliberate identity key to reset a whole stateful subtree, not as a routine refresh mechanism.

## Stateful component changes tree position

Symptom: conditional branches place the same stateful component under different ancestor types or positions, so local state resets unexpectedly.

```tsx
// Wrong: changing the parent component remounts Counter.
return isFancy
  ? <FancyPanel><Counter /></FancyPanel>
  : <PlainPanel><Counter /></PlainPanel>

// Rewrite: one parent type, one Counter position.
return <Panel variant={isFancy ? "fancy" : "plain"}><Counter /></Panel>
```

Use a key only when the conceptual entity should reset.

## Parent and child duplicate the same state

Symptom: both components store the same value and must call paired setters to remain synchronized.

```tsx
// Rewrite: one owner, one value.
function Parent() {
  const [name, setName] = useState("")
  return <NameInput value={name} onChange={setName} />
}

function NameInput(props: { value: string; onChange: (value: string) => void }) {
  return (
    <input
      value={props.value}
      onChange={(event) => props.onChange(event.target.value)}
    />
  )
}
```

Lift state to the nearest common owner or make the child controlled.

## Render performs a side effect

Symptom: rendering starts a request or timer, writes storage or the DOM, calls a setter on another component, or mutates module state.

Rewrite: keep render pure. Move interaction-driven work into the event handler and external synchronization into an effect.

```tsx
// Wrong: starts work while rendering.
if (shouldTrack) analytics.track("view")

// Rewrite: synchronize display-driven analytics after commit.
useEffect(() => {
  if (shouldTrack) analytics.track("view")
}, [shouldTrack])
```

## Setter is read as an immediate mutation

Symptom: an event calls a setter and then uses the old state variable as though React changed it immediately.

```tsx
// Wrong.
setCount(count + 1)
if (count === limit) finish()

// Rewrite.
const nextCount = count + 1
setCount(nextCount)
if (nextCount === limit) finish()
```

Use a functional update instead when the next value must use the latest queued state.

## Non-rendered transient value stored in state

Symptom: timer IDs, pointer coordinates, imperative instances, or mutable flags trigger renders even though JSX never reads them.

Rewrite: store them in `useRef`. Keep any value that affects visible output in state.

```tsx
const timeoutId = useRef<ReturnType<typeof setTimeout> | null>(null)
```

## Memoized component creates a default reference

Symptom: a memoized component defaults an object, array, or function in its parameter, producing a new reference on every call.

```tsx
// Wrong.
const UserList = memo(function UserList(props: { users?: User[] }) {
  const { users = [] } = props
  return <List users={users} />
})

// Rewrite.
const EMPTY_USERS: readonly User[] = []
const UserList = memo(function UserList(props: { users?: readonly User[] }) {
  const users = props.users ?? EMPTY_USERS
  return <List users={users} />
})
```

Apply this only where reference stability reaches a real memoization boundary.

## Hook runs conditionally

Symptom: a Hook appears after an early return or inside a condition, loop, callback, or `try` block.

```tsx
// Wrong.
if (!user) return null
const [draft, setDraft] = useState("")

// Rewrite when the state belongs to this component.
const [draft, setDraft] = useState("")
if (!user) return null
```

If the Hook belongs only to one branch, extract that branch into a child component and render the child conditionally.

## Prop copied into state without an ownership decision

Symptom: `useState(props.name)` creates a local copy that becomes stale or needs an effect to overwrite edits.

Rewrite: read the prop directly when no local editing exists. Make the component controlled when the parent owns the value. For an editable draft tied to an entity, keep local state in a keyed editor such as `<Editor key={user.id} initialName={user.name} />`.

Do not blindly sync every prop change into local state; that can erase in-progress edits.

## Coupled fields updated by separate transition logic

Symptom: several setters must always run together, handlers duplicate the same transition, or intermediate combinations are invalid.

Rewrite: compute one next object or use `useReducer` with one action describing the complete transition. Do not introduce a reducer for simple independent fields.

## Existing state or props are mutated

Symptom: render code, an event, an effect, or a callback mutates an existing React value and passes the same reference back.

```tsx
// Wrong.
items.push(newItem)
setItems(items)
user.name = nextName
setUser(user)

// Rewrite.
setItems((current) => [...current, newItem])
setUser((current) => ({ ...current, name: nextName }))
```

## Event handler invoked during render

Symptom: JSX calls a handler or setter instead of passing a function.

```tsx
// Wrong.
<button onClick={saveUser(user)}>Save</button>
<button onClick={setOpen(true)}>Open</button>

// Rewrite.
<button onClick={() => saveUser(user)}>Save</button>
<button onClick={() => setOpen(true)}>Open</button>
```

Pass an existing function directly when no arguments need binding.

## Controlled input changes ownership

Symptom: an input starts with `undefined` and later receives a value, or alternates between `value` and `defaultValue`.

```tsx
// Wrong.
<input value={user?.name} onChange={handleChange} />

// Rewrite as controlled.
<input value={user?.name ?? ""} onChange={handleChange} />
```

For intentionally uncontrolled input, use `defaultValue` and never later supply `value`.

## Component called as a function

Symptom: React code invokes `UserCard({ user })` instead of rendering the component.

```tsx
// Wrong.
return UserCard({ user })

// Rewrite.
return <UserCard user={user} />
```

Call ordinary render helpers as functions only when they are not components and do not use Hooks.
