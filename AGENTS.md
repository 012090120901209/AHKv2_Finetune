# AGENTS.md

This file provides guidance to agents when working with code in this repository.

## Project Overview

This is an AutoHotkey v2 fine-tuning dataset project with ~1,873 AHK example scripts, AI-powered validation tools, and ML training infrastructure.

## Key Commands

### Python Testing
```bash
# Run all tests
python -m unittest discover tests -v

# Run specific test file
python -m unittest tests.test_build_dataset -v

# Run specific test method
python -m unittest tests.test_build_dataset.TestDedupe.test_removes_duplicates -v
```

### AHK Script Validation/Formatting
```bash
# Check formatting only (no changes)
python scripts/format_ahk_examples.py --root data/Scripts --check

# Apply safe text fixes (BOM, whitespace, header ordering)
python scripts/format_ahk_examples.py --root data/Scripts --fix

# Format with THQBY formatter (auto-clones/builds to .cache/thqby)
python scripts/format_ahk_examples.py --root data/Scripts --thqby --fix
```

### AI Agent Harness (requires ANTHROPIC_API_KEY)
```bash
# Quick validation (no AI)
python tools/agent-harness/agent.py validate data/Scripts/script.ahk

# Fix scripts with AI
python tools/agent-harness/agent.py fix data/Scripts/ --recursive --level=semantic

# List all validation rules
python tools/agent-harness/rules_engine.py list
```

### Node.js AHK Linter
```bash
cd tools/ahk-linter
npm install
npm run build
npm run lint  # Lints test file
npx ts-node index.ts lint path=../../data/Scripts/script.ahk
```

## Critical Non-Obvious Patterns

### AHK Script Rules (data/Scripts/)
- All scripts MUST follow rules in [`data/Scripts/AGENTS.md`](data/Scripts/AGENTS.md)
- Header directive order: `#Requires` → `#SingleInstance` → `#Include` (enforced by formatter)
- UTF-8 without BOM is required (formatter strips BOM)
- File naming: `[Category]_[Number]_[Description].ahk` or `[Category]_[Feature]_[Detail].ahk`
- Category/folder names are used as metadata in dataset prompts

### THQBY Formatter Gotcha
- The upstream THQBY CLI has a bug with filenames containing `=` (e.g., `String_!= Conversion.ahk`)
- The formatter script auto-patches `.cache/thqby/vscode-autohotkey2-lsp/server/cli/cli.ts` before building
- If using `--no-bootstrap`, the patch won't be applied and files with `=` will fail

### Agent Harness Architecture
- Uses Claude API for AI-powered fixes (set `ANTHROPIC_API_KEY` environment variable)
- Fix levels: `formatting` (headers/whitespace), `syntax` (v1→v2), `semantic` (naming/comments), `full` (expansion)
- Rules engine parses `data/Scripts/AGENTS.md` and documentation into structured validation rules
- Custom Claude agents defined in [`.claude/agents/`](.claude/agents/) for use with Task tool

### Dataset Building
- `src/build_dataset.py` uses SHA256 hashing for deduplication
- Converts raw AHK snippets to JSONL training pairs with Harmony chat format
- Reference data from `data/elements.csv` is integrated into prompts
- Train/val/test splits are reproducible (seeded)

### Code Style (AHK)
- 4 spaces per indentation level (no tabs)
- CRLF line endings (Windows compatibility)
- Function names: camelCase or PascalCase
- Class names: PascalCase
- Opening brace on same line as function/class header
- Closing brace on new line, aligned with start

### Code Style (Python)
- Uses `unittest` framework (not pytest)
- Test files in `tests/` directory
- Test naming: `test_<functionality>.py`, classes `Test<Feature>`, methods `test_<specific_case>`

## Directory Structure Notes

- `data/Scripts/` - Canonical AHK v2 examples (primary dataset source)
- `src/` - Python training scripts (build_dataset.py, data_prep.py, train_qlora.py)
- `tools/agent-harness/` - AI validation/fixing harness
- `tools/ahk-linter/` - Node.js LSP-based linter wrapper
- `tests/` - Python unit tests (38 tests total)
- `.claude/agents/` - Custom agent definitions for Claude Code Task tool
