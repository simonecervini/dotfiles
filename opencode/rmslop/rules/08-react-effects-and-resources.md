# React effects and resources

Audit every `useEffect` added or materially changed.

## Effect has no external system

Symptom: the effect does not synchronize a browser API, network resource, subscription, timer, non-React widget, or display-triggered analytics.

Rewrite: remove it. If the body only calculates state, derive during render. If it reacts to an interaction, call it from that event. If it synchronizes duplicate React state, lift ownership. If it resets a conceptual entity, use a key at the narrowest stateful boundary.

## Interaction is modelled as state plus effect

Symptom: `submitted`, `clicked`, `saved`, or another flag triggers a POST, navigation, or notification.

```tsx
// Wrong.
useEffect(() => {
  if (submitted) postForm()
}, [submitted])

// Rewrite.
function handleSubmit() {
  postForm()
}
```

Keep display-driven behavior in an effect; move interaction-driven behavior to the event.

## Effect chain models a state transition

Symptom: one effect updates state solely to trigger the next effect.

```tsx
// Wrong.
useEffect(() => {
  if (card?.gold) setGoldCount((count) => count + 1)
}, [card])
useEffect(() => {
  if (goldCount === 3) setRound((round) => round + 1)
}, [goldCount])

// Rewrite as one pure transition.
function gameReducer(state: GameState, action: GameAction): GameState {
  if (action.type !== "placeCard") return state
  if (!action.card.gold) return { ...state, card: action.card }

  return state.goldCount < 2
    ? { ...state, card: action.card, goldCount: state.goldCount + 1 }
    : { ...state, card: action.card, goldCount: 0, round: state.round + 1 }
}
```

Dispatch this transition from the event. A state updater must stay pure; never call another setter inside it.

## Child notifies parent after rendering

Symptom: local state changes, then an effect calls `props.onChange(localState)`.

```tsx
// Wrong.
useEffect(() => props.onChange(value), [props.onChange, value])

// Rewrite.
function updateValue(nextValue: string) {
  setValue(nextValue)
  props.onChange(nextValue)
}
```

Prefer a controlled child when both components store the same value.

## Child pushes fetched data upward

Symptom: a child fetches or reads shared data, then an effect passes it into parent state.

```tsx
// Wrong.
function Parent() {
  const [data, setData] = useState<Data | null>(null)
  return <Child onData={setData} />
}
function Child(props: { onData: (data: Data) => void }) {
  const data = useData()
  useEffect(() => props.onData(data), [data, props.onData])
  return <View data={data} />
}

// Rewrite.
function Parent() {
  const data = useData()
  return <Child data={data} />
}
```

Move the data source to the nearest common parent and pass the result down. Keep child-owned data in the child when no other component needs it.

## Identity change clears state in an effect

Symptom: an effect resets a form or nested state when `userId`, `contactId`, or another identity changes.

```tsx
// Wrong.
useEffect(() => setDraft(""), [userId])

// Rewrite at the stateful boundary.
return <ProfileEditor key={userId} userId={userId} />
```

Use a key only when the subtree represents a different conceptual entity. Put it at the narrowest stateful boundary and confirm losing drafts, focus, refs, and active resources is intended.

## Setup has no matching cleanup

Symptom: the effect adds a listener, timer, connection, subscription, widget, or request without undoing it.

```tsx
// Wrong.
useEffect(() => {
  window.addEventListener("resize", handleResize)
}, [])

// Rewrite.
useEffect(() => {
  function handleResize() {
    setWidth(window.innerWidth)
  }

  window.addEventListener("resize", handleResize)
  return () => window.removeEventListener("resize", handleResize)
}, [])
```

Setup and cleanup must remain correct under remounting.

## Dependency array lies

Symptom: `exhaustive-deps` is suppressed or a reactive value read by the effect is omitted to control reruns.

```tsx
// Wrong.
// eslint-disable-next-line react-hooks/exhaustive-deps
useEffect(() => {
  const connection = connect(roomId)
  return () => connection.disconnect()
}, [])

// Rewrite.
useEffect(() => {
  const connection = connect(roomId)
  return () => connection.disconnect()
}, [roomId])
```

If complete dependencies rerun too often, change the code read by the effect; do not change the array to hide reads.

## Dependency is broader than the value used

Symptom: the effect reads `user.id` but depends on the whole `user`, or reacts to every width change but only cares about a breakpoint.

```tsx
// Wrong.
useEffect(() => {
  const connection = connect(user.id)
  return () => connection.disconnect()
}, [user])

// Rewrite.
useEffect(() => {
  const connection = connect(user.id)
  return () => connection.disconnect()
}, [user.id])
```

Narrow the effect body first so it visibly uses only the listed primitive. Derive semantic dependencies such as `isMobile` when synchronization changes only at that boundary.

## Render-created object forces reruns

Symptom: an object or function created during render appears in the dependency array and restarts synchronization every render.

```tsx
// Wrong.
const options = { roomId, serverUrl }
useEffect(() => {
  const connection = connect(options)
  return () => connection.disconnect()
}, [options])

// Rewrite.
useEffect(() => {
  const options = { roomId, serverUrl }
  const connection = connect(options)
  return () => connection.disconnect()
}, [roomId, serverUrl])
```

Hoist the value instead when it is completely static.

## One effect synchronizes unrelated systems

Symptom: changing one dependency restarts analytics, document title, subscriptions, and connections together.

```tsx
// Wrong.
useEffect(() => {
  analytics.page(pathname)
  document.title = title
}, [pathname, title])

// Rewrite.
useEffect(() => {
  analytics.page(pathname)
}, [pathname])
useEffect(() => {
  document.title = title
}, [title])
```

Keep setup steps together when they form one resource lifecycle.

## Non-reactive callback forces reconnection

Symptom: an effect reconnects only because a callback or latest value changed, although that value should not control synchronization.

```tsx
const handleConnected = useEffectEvent(props.onConnected)

useEffect(() => {
  const connection = connect(props.roomId)
  connection.on("connected", () => handleConnected())
  return () => connection.disconnect()
}, [props.roomId])
```

Use `useEffectEvent` only when supported. Call it only from the effect or resources created by it. Do not include it in dependencies or use it to hide a genuinely reactive value.

## External store copied manually into state

Symptom: an effect subscribes to a mutable external store and mirrors snapshots into component state.

```tsx
// Wrong: a manual mirror.
useEffect(() => store.subscribe(() => setValue(store.getSnapshot())), [store])

// Rewrite for a module-level store.
const subscribe = (notify: () => void) => store.subscribe(notify)
const getSnapshot = () => store.getSnapshot()
const getServerSnapshot = () => store.getServerSnapshot()

const value = useSyncExternalStore(
  subscribe,
  getSnapshot,
  getServerSnapshot,
)
```

Snapshots must keep the same reference while data is unchanged. Prefer the project's existing store hook when it already wraps this API.

## Fetch response race

Symptom: an effect commits every response, allowing an old request to overwrite newer data.

```tsx
useEffect(() => {
  const controller = new AbortController()

  async function load() {
    try {
      const results = await loadResults(query, { signal: controller.signal })
      setResults(results)
    } catch (error) {
      if (!controller.signal.aborted) reportError(error)
    }
  }

  void load()
  return () => controller.abort()
}, [query])
```

Prefer the framework's data loader. If abort is unavailable, set an `ignore` flag in cleanup and check it before committing the response.

## Subscription reads state only to append

Symptom: a subscription effect reads `messages` for `setMessages([...messages, message])`, forcing reconnection whenever messages change.

```tsx
// Rewrite.
useEffect(() => {
  return props.subscribe((message) => {
    setMessages((current) => [...current, message])
  })
}, [props.subscribe])
```

Remove only dependencies no longer read after the functional update.

## Empty-dependency effect assumes app-once execution

Symptom: `useEffect(..., [])` performs application-wide initialization that breaks when the component remounts.

Rewrite: make component setup idempotent and cleanup complete. If the operation belongs to app startup rather than component presence, call it from the application entry point before rendering.

Do not use an arbitrary module-global guard in server-rendered code; module state is shared across requests.

## Async function passed directly to useEffect

Symptom: `useEffect(async () => { ... }, dependencies)` returns a promise instead of a cleanup function.

```tsx
// Wrong.
useEffect(async () => {
  setResults(await loadResults(query))
}, [query])

// Rewrite: keep the effect callback synchronous.
useEffect(() => {
  let ignore = false

  async function load() {
    try {
      const results = await loadResults(query)
      if (!ignore) setResults(results)
    } catch (error) {
      if (!ignore) reportError(error)
    }
  }

  void load()
  return () => {
    ignore = true
  }
}, [query])
```
