# Tests and test doubles

## New coverage was not requested

Symptom: the change adds test cases, snapshots, fixtures, or test files even though the user did not request new tests.

Rewrite: remove the new coverage. Running existing tests remains allowed.

## Existing test became stale

Symptom: the implementation intentionally changed behavior or a contract, but existing assertions, snapshots, fixtures, or setup still encode the old behavior.

Rewrite: update only the stale existing test material. Do not use this as permission to add unrelated cases.

## Module mock replaces architecture

Symptom: tests add `vi.mock`, `vi.doMock`, `jest.mock`, or `jest.unstable_mockModule` for application modules.

```ts
// Wrong.
vi.mock("./user-store")

// Rewrite: inject the dependency.
const userStore = new InMemoryUserStore()
const service = createUserService({ userStore })
```

Prefer real interfaces, service layers, in-memory implementations, or faithful test collaborators. A spy on an explicitly injected dependency is not module mocking.

Preserve an established module mock only when modifying an existing test requires it; do not spread the pattern to new modules.

Computed access and renamed framework imports are still module mocks, such as `vi["doMock"](...)` or `import { vi as testApi }`. Do not flag a local object merely because it happens to be named `vi` or has a method named `mock`.
