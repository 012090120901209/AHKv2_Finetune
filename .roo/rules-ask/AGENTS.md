# AGENTS.md - Ask Mode

This file provides guidance for ask mode operations in this repository.

## Non-Obvious Documentation Rules

### Project Structure Counterintuitions
- `src/` contains Python training scripts, not source code for web apps
- `data/Scripts/` is the canonical AHK v2 examples dataset (~1,873 files)
- `tools/agent-harness/` contains AI validation/fixing harness (not just scripts)
- `tools/ahk-linter/` is a Node.js wrapper around THQBY LSP server
- `.claude/agents/` contains custom Claude Code agent definitions for Task tool

### AHK Script Organization
- Category/folder names in `data/Scripts/` are used as metadata in dataset prompts
- File naming patterns: `[Category]_[Number]_[Description].ahk` or `[Category]_[Feature]_[Detail].ahk`
- All scripts MUST follow rules in `data/Scripts/AGENTS.md` (not just general AHK v2 syntax)
- Header directive order is enforced: `#Requires` → `#SingleInstance` → `#Include`

### Dataset Pipeline Context
- `src/build_dataset.py` converts raw AHK snippets to JSONL training pairs
- Uses SHA256 hashing for deduplication (identical content produces same hash)
- Reference data from `data/elements.csv` is integrated into prompts
- `src/data_prep.py` converts JSONL to Harmony chat format for training
- Train/val/test splits are reproducible (seeded random)

### Tooling Gotchas
- THQBY formatter auto-clones/builds to `.cache/thqby/` directory
- Upstream THQBY CLI has bug with filenames containing `=` - formatter auto-patches this
- Using `--no-bootstrap` skips the patch - files with `=` will fail
- Agent harness requires `ANTHROPIC_API_KEY` for AI-powered fixes

### Testing Framework
- Uses `unittest` framework (not pytest) - tests in `tests/` directory
- Test naming: `test_<functionality>.py`, classes `Test<Feature>`, methods `test_<specific_case>`
- Run tests: `python -m unittest discover tests -v` or specific test methods
