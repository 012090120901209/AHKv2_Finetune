# Plan: AutoHotkey v2 Module-Based String and Array Utilities

## Goals
- Provide reusable string and array helpers that leverage the v2 `#Module` import system for clear namespaces and predictable dependencies.
- Keep APIs small, composable, and safe for inclusion in other scripts without polluting global scope.
- Offer example usage patterns that mirror the existing module guide so contributors can extend consistently.

## Target Structure
- Location: `scripts/v2/utils/` (mirrors module examples already in the repo).
- Modules:
  - `StringUtils.ahk` → `#Module StringUtils` with exported string helpers.
  - `ArrayUtils.ahk` → `#Module ArrayUtils` with exported array helpers.
- Consumer scripts live in `scripts/v2/examples/` and import modules explicitly:

```autohotkey
Import StringUtils
Import { Chunk, Unique } from ArrayUtils as Arr
```

## Exported API (Initial Set)
### StringUtils
- `Export ToTitle(text)` – Title-case words while respecting existing capitalization tokens.
- `Export TrimAll(text, chars := " \t\r\n")` – Trim from both sides, defaulting to whitespace.
- `Export CollapseWhitespace(text)` – Replace multi-space runs with a single space.
- `Export ReplaceAll(text, search, replace, caseSensitive := false)` – Multi-instance replacement.
- `Export SplitLines(text, keepEmpty := false)` – Normalize `\r\n`/`\n`/`\r` into arrays.
- `Export StartsWith(text, prefix, caseSensitive := false)` / `Export EndsWith(text, suffix, caseSensitive := false)` – Boolean predicates.
- `Export Join(list, delimiter := ", ")` – Stringify arrays with a delimiter; defends against non-array inputs.

### ArrayUtils
- `Export Chunk(arr, size)` – Break array into sub-arrays with size validation.
- `Export Flatten(arr, depth := 1)` – Shallow/controlled flattening to avoid surprises.
- `Export Unique(arr, key := "")` – De-duplicate primitives or objects using an optional key selector.
- `Export GroupBy(arr, keyFunc)` – Returns `{key: [items]}` map; validates callable.
- `Export SortBy(arr, keyFunc, descending := false)` – Stable sort wrapper around `Sort` with projection function.
- `Export Zip(arrays*)` – Combine arrays element-wise, stopping at the shortest input.
- `Export FindIndex(arr, predicate)` – Return first index matching predicate or `0` when missing.

## Implementation Notes
- Declare `#Requires AutoHotkey v2.1-alpha.17` (matches module guide baseline).
- Place reusable helpers before example consumers to keep imports predictable.
- Each module should guard against invalid input types with concise parameter checks and clear error messages.
- Use `Export` on every public symbol; keep private helpers unexported to avoid namespace leaks.
- Prefer pure functions; avoid global state and GUI/IO side effects inside modules.

## Example Consumer (Smoke Test)
`scripts/v2/examples/test_string_array_modules.ahk`
```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

Import StringUtils
Import ArrayUtils as Arr

sample := "hello  world`nfrom ahk"
MsgBox(StringUtils.ToTitle(sample))
MsgBox(StringUtils.Join(["a", "b", "c"], " | "))

numbers := [1,2,2,3,4,4]
unique := Arr.Unique(numbers)
chunks := Arr.Chunk(unique, 2)
chunkText := ""
for i, block in chunks
    chunkText .= "[" StringUtils.Join(block, ",") "] "
MsgBox("Unique: " StringUtils.Join(unique) "`nChunks: " chunkText)
```

## Testing Plan
- Add minimal unit-like scripts under `scripts/v2/tests/` that `Import` modules and assert outputs via `Throw` on mismatch.
- Provide a one-shot runner `scripts/v2/tests/run_all.ahk` that sequentially executes test scripts for quick verification.
- Include a README snippet showing how to run tests with `AutoHotkey64.exe scripts/v2/tests/run_all.ahk`.

## Rollout Steps
1. Scaffold `scripts/v2/utils/` with both modules and headers (`#Module`, `#Requires`).
2. Implement the initial exported functions with parameter validation and inline docs.
3. Add the example consumer script and lightweight tests.
4. Wire modules into existing documentation (module guide + example catalog) after verifying imports.
5. Publish regeneration instructions (e.g., `node`/`python` snippets) if counts/examples are updated.

## Risks and Mitigations
- **Version mismatch**: Align with the module guide version (`v2.1-alpha.17+`); document if newer features are required.
- **Namespace collisions**: Keep exports minimal and namespaced; advise selective imports for large consumers.
- **Type safety**: Add early type checks and descriptive errors to avoid silent failures in automation scripts.

