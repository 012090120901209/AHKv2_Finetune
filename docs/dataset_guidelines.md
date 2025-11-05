## AHK v2 Dataset Curation Guidelines

### Scope

- Applies to every snippet under `data/raw_scripts` (and subfolders) destined for JSONL export via `src/build_dataset.py`.
- Covers naming conventions, documentation tone, and acceptable references when adapting AHK v1 materials to AHK v2.
- Keep snippets runnable in AutoHotkey v2 on Windows 10+.

### File Naming

- Use descriptive, task-centric stems: `Hotkey_Label_Chaining`, `Clipboard_Watcher`, `Gui_MenuInit`.
- Avoid migration or bug-tracker language (`V1toV2`, `Issue_#123`, `StressTest`). If historical context matters, capture it in comments (see below).
- Prefer CamelCase or snake_case consistently within a folder; revisit legacy stems when cleaning a batch.
- Suffix numerals only when variants exist (`Gui_MenuInit_01`, `_02`). Ensure numerals match documentation references.

### Function, Label, and Variable Names

- Align identifiers with their role: `InitGlobalState()`, `HandleHotkey()`, `ShowTooltip()`, etc.
- Remove converter artefacts like `V1toV2_GblCode_001`. Map them to semantically meaningful names (`RunStartupBlock`).
- When labels remain necessary, switch to verbs or outcomes: `StartLoop:`, `HandleEscape:`.
- Keep naming consistent across comment descriptions, GUI bindings, and hotkey definitions.

### Comment Style

- Begin files with a one-line summary describing the automation pattern.
- Use comments to explain behaviours, inputs, or edge cases; omit migration test chatter.
- Convert issue references into narrative context: `; Demonstrates menu parameter mismatch from legacy bug (originally tracked as #131).`
- For multi-line explanations, prefer bullet-like formatting with `; - ` for clarity.

### Content Expectations

- Preserve minimal examples: remove redundant `MsgBox`/`Sleep` calls added purely for converter validation unless they illustrate timing.
- Ensure hotkeys, GUIs, and callbacks reflect idiomatic AHK v2 usage (e.g., bound functions instead of legacy command syntax).
- Verify that global declarations (`global` inside functions) serve a purpose; remove leftovers from conversion scaffolding.
- Keep directive samples (`#Warn`, `#HotIf`) focused on the directive behaviour, not on converter regression notes.

### Metadata Awareness

- Each snippet will be embedded into prompts using folder/category names; ensure folder placement matches topic.
- When renaming files, update any cross-references (e.g., `Yunit_tests` drivers) to prevent broken includes.
- Maintain UTF-8 encoding without BOM. Strip BOMs if encountered, but verify AutoHotkey still loads the file correctly.

### Review Checklist

1. **Inventory**: Run `Select-String -Pattern "V1toV2|Issue #|Stress Test|converter" -Path data/raw_scripts/**/*.ah2` to flag suspect files.
2. **Rename & Refactor**: Apply the naming rules, adjust identifiers, and rewrite comments for clarity.
3. **Functional Sanity**: Execute edited snippets with AutoHotkey v2 (`AutoHotkey64.exe /ErrorStdOut path\snippet.ah2`) to validate syntax/runtime behaviour.
4. **Dataset Dry Run**: `python -m src.build_dataset --input-dir data/raw_scripts --output-dir data/prepared --dry-run` to confirm clean exports.
5. **Finalize**: Re-run without `--dry-run`, commit changes, and sync prepared JSONLs to downstream environments.

### Automation Support

- A helper script can bulk-replace common artefacts (see `scripts/normalize_snippets.py`). Use a dry-run mode first.
- Log all automated edits (JSON or CSV) to assist manual spot-checking.
- Pause cloud sync clients (OneDrive) before mass renames to avoid locked files.

### Ongoing Maintenance

- Revisit the guidelines whenever introducing new snippet categories or importing upstream examples.
- Document deliberate exceptions (e.g., regression reproductions that must keep legacy naming) in a README within the relevant folder.
- Keep this file updated as the fine-tuning pipeline evolves (e.g., if prompt schema changes or additional metadata fields are required).

