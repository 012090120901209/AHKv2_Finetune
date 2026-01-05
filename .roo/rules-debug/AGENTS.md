# AGENTS.md - Debug Mode

This file provides guidance for debug mode operations in this repository.

## Non-Obvious Debug Rules

### AHK Script Validation
- Use `python scripts/format_ahk_examples.py --root data/Scripts --check` for quick validation
- THQBY formatter errors on files with `=` in filename - check `.cache/thqby/` if formatter fails
- Formatter auto-patches upstream THQBY CLI bug - check patch was applied if files with `=` fail
- UTF-8 BOM issues are stripped automatically by formatter

### Python Debugging
- Tests use `unittest` framework - run with `python -m unittest tests.test_build_dataset -v` for verbose output
- Dataset builder uses SHA256 hashing - identical content produces same hash (useful for deduplication debugging)
- Train/val/test splits are seeded - reproducible for debugging data pipeline issues

### Agent Harness Debugging
- AI fixes require `ANTHROPIC_API_KEY` - silent failures if not set
- Rules engine: `python tools/agent-harness/rules_engine.py list` shows all validation rules
- Quick validation without AI: `python tools/agent-harness/agent.py validate data/Scripts/script.ahk`
- Fix levels: `formatting`, `syntax`, `semantic`, `full` - test incrementally

### Node.js Linter Debugging
- Must build TypeScript first: `cd tools/ahk-linter && npm run build`
- Linter wraps THQBY LSP server - check Node.js >= 18 requirement
- Test with `npm run lint` (runs on test file in package.json)
- Direct lint: `npx ts-node index.ts lint path=../../data/Scripts/script.ahk`

### Common Silent Failures
- THQBY formatter with `--no-bootstrap` fails silently on files with `=` in name
- Agent harness without `ANTHROPIC_API_KEY` fails to make AI fixes
- Missing UTF-8 encoding causes decode errors in dataset builder
- Header directive order violations only caught by formatter, not by simple validation
