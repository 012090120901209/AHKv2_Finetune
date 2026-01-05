# AGENTS.md - Architect Mode

This file provides guidance for architect mode operations in this repository.

## Non-Obvious Architectural Constraints

### Dataset Pipeline Architecture
- `src/build_dataset.py` uses SHA256 hashing for deduplication - identical content produces same hash
- Converts raw AHK snippets to JSONL training pairs with Harmony chat format
- Reference data from `data/elements.csv` is integrated into prompts
- `src/data_prep.py` transforms JSONL to Harmony chat format for training
- Train/val/test splits are reproducible (seeded random) - critical for consistent experiments

### AHK Script Dataset Structure
- `data/Scripts/` contains ~1,873 canonical AHK v2 examples (primary dataset source)
- Category/folder names are used as metadata in dataset prompts - structural coupling
- File naming patterns: `[Category]_[Number]_[Description].ahk` or `[Category]_[Feature]_[Detail].ahk`
- All scripts MUST follow rules in `data/Scripts/AGENTS.md` (enforced by validation pipeline)

### Tooling Architecture
- `tools/agent-harness/` wraps Claude API for AI-powered fixes (requires `ANTHROPIC_API_KEY`)
- Rules engine parses `data/Scripts/AGENTS.md` into structured validation rules
- `tools/ahk-linter/` is a Node.js wrapper around THQBY LSP server (requires Node.js >= 18)
- THQBY formatter auto-clones/builds to `.cache/thqby/` directory
- Upstream THQBY CLI has bug with filenames containing `=` - formatter auto-patches `.cache/thqby/vscode-autohotkey2-lsp/server/cli/cli.ts`

### Hidden Coupling
- Category/folder names in `data/Scripts/` become metadata in training prompts
- Header directive order (`#Requires` → `#SingleInstance` → `#Include`) is enforced by formatter
- UTF-8 without BOM is required (formatter strips BOM automatically)
- Dataset builder expects specific file naming patterns for metadata extraction

### Testing Architecture
- Uses `unittest` framework (not pytest) - tests in `tests/` directory
- Test naming: `test_<functionality>.py`, classes `Test<Feature>`, methods `test_<specific_case>`
- Run tests: `python -m unittest discover tests -v` or specific test methods
- 38 total tests covering dataset building and data preparation

### Custom Agent Integration
- `.claude/agents/` contains custom Claude Code agent definitions for Task tool
- Three agents: `ahk-fixer` (fix scripts), `ahk-linter` (analyze only), `ahk-generator` (create new examples)
- Fix levels: `formatting` (headers/whitespace), `syntax` (v1→v2), `semantic` (naming/comments), `full` (expansion)
