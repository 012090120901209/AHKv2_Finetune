# AutoHotkey v2 Example Rules (this folder)

This folder contains the canonical AutoHotkey v2 “example files” used by the dataset tooling and docs in this repo. Keep every `.ahk` file here consistent and easy to ingest.

Sources these rules were distilled from:
- `docs/dataset_guidelines.md`
- `docs/AHK_v2_Alpha_Modern_Guide.md`
- `docs/AHK_v2_Examples_Feature_Guide.md`
- `wiki/Getting-Started.md`
- `wiki/Dataset-Building.md`
- `research/AHK_V2_EXAMPLES_COMPLETE_GUIDE.md`

## Required (every example)

### 1) v2 header directive

Every file MUST include a `#Requires` line for v2:

```ahk
#Requires AutoHotkey v2.0
```

If the example genuinely depends on a newer v2.1-alpha feature, bump the version and keep it consistent with the feature used (don’t “upgrade” just because).

### 2) Safe-to-run single instance

Examples SHOULD include:

```ahk
#SingleInstance Force
```

If you omit it (rare), document why in the file header (e.g., the example intentionally demonstrates multi-instance behavior).

### 3) Clear description at the top

Every file MUST explain what it demonstrates near the top of the file. Either is acceptable:

- A one-line `;` summary (simple examples), or
- A short `/** ... */` doc block (larger examples).

Keep it factual and task-centric (avoid “converter test”, “issue #123”, etc. in the user-facing description).

### 4) Pure AHK v2 syntax

Examples MUST be valid AutoHotkey v2 (expression-based) code:
- No v1 command syntax (e.g., `MsgBox, Hello`).
- Use parentheses for calls (e.g., `MsgBox("Hello")`).
- Keep hotkeys/GUI/callbacks idiomatic for v2.

### 5) Standalone, or dependencies explicitly declared

Examples MUST be runnable as-written OR clearly declare dependencies:
- Prefer self-contained examples.
- If you need a library, use `#Include` and keep it near the top of the file.
- If the include points to an external library not vendored in this repo, still include it (to teach syntax), but make the dependency obvious in the header text.

To sanity-check include paths, use `scripts/validate_includes.py` (see `wiki/Getting-Started.md` and `wiki/Project-Architecture.md`).

## Strong conventions (keep the dataset clean)

### Naming and placement

- File names SHOULD be descriptive and task-centric.
- Prefer patterns already used in this repo, such as:
  - `[Category]_[Number]_[Description].ahk` (e.g., `Array_01_Chunk.ahk`)
  - `[Category]_[Feature]_[Detail].ahk` (e.g., `Advanced_Class_EventEmitter.ahk`)
- Use numerals only for true variants (`_01`, `_02`, etc.).
- Place the file under the correct category folder; category/folder and filename are used as metadata in dataset prompts.

### Comments and tone

- Keep comments educational but tight: explain behavior, inputs, and edge cases.
- For multi-line explanations, prefer bullet-like `; - ` lines.
- Avoid hardcoded machine-specific paths, credentials, or personal data.

### Encoding

- Save files as UTF-8 without BOM.

