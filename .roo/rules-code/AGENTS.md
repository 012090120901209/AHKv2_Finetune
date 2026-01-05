# AGENTS.md - Code Mode

This file provides guidance for code mode operations in this repository.

## Non-Obvious Coding Rules

### AHK Script Modifications
- Header directive order is enforced: `#Requires` → `#SingleInstance` → `#Include` (formatter auto-reorders)
- UTF-8 without BOM is mandatory (formatter strips BOM automatically)
- Category/folder names become metadata in dataset prompts - don't rename folders arbitrarily
- File naming patterns: `[Category]_[Number]_[Description].ahk` or `[Category]_[Feature]_[Detail].ahk`

### THQBY Formatter Critical Gotcha
- Upstream THQBY CLI fails on filenames with `=` (e.g., `String_!= Conversion.ahk`)
- Formatter script auto-patches `.cache/thqby/vscode-autohotkey2-lsp/server/cli/cli.ts` before building
- Using `--no-bootstrap` skips the patch - files with `=` will fail
- Always run formatter from project root to ensure patch is applied

### Python Code Patterns
- Use `unittest` framework (not pytest) - tests in `tests/` directory
- Test naming: `test_<functionality>.py`, classes `Test<Feature>`, methods `test_<specific_case>`
- Run tests: `python -m unittest discover tests -v` or `python -m unittest tests.test_build_dataset.TestDedupe.test_removes_duplicates -v`

### Node.js Linter (tools/ahk-linter/)
- Must build TypeScript before running: `npm run build`
- Linter wraps THQBY LSP server - requires Node.js >= 18
- Test command: `npm run lint` (runs on test file)
- Direct lint: `npx ts-node index.ts lint path=../../data/Scripts/script.ahk`

### Dataset Building (src/build_dataset.py)
- Uses SHA256 hashing for deduplication - identical content produces same hash
- Converts AHK snippets to Harmony chat format JSONL
- Reference data from `data/elements.csv` is integrated into prompts
- Train/val/test splits are reproducible (seeded random)

### Agent Harness Integration
- AI fixes require `ANTHROPIC_API_KEY` environment variable
- Fix levels: `formatting`, `syntax`, `semantic`, `full`
- Rules engine parses `data/Scripts/AGENTS.md` into structured validation
- Custom agents in `.claude/agents/` for Task tool usage
