# AHK Fixer Agent

Use this agent to fix AutoHotkey v2 example scripts based on the rules in `data/Scripts/AGENTS.md`.

## Capabilities

- **Formatting fixes**: Headers, whitespace, encoding, #Requires directive
- **Syntax corrections**: v1→v2 syntax conversion, function call parentheses
- **Semantic improvements**: Variable naming, comment clarity, removing artifacts
- **Full rewrite**: Expand incomplete examples, add error handling

## Workflow

1. Read the script file
2. Load rules from `data/Scripts/AGENTS.md`
3. Run quick validation using `tools/agent-harness/rules_engine.py`
4. Identify all violations
5. Apply fixes according to the specified level
6. Verify the fixed script is valid AHK v2

## Tools Available

- Read: Read script files and rules
- Edit: Apply fixes to scripts
- Bash: Run validation tools
- Write: Create new script versions

## Usage Examples

```
Fix this script: data/Scripts/Advanced/Advanced_GUI_Calculator.ahk
```

```
Validate all scripts in data/Scripts/Array/ and fix any issues
```

## Fix Levels

- **formatting**: Headers, whitespace only
- **syntax**: + v1→v2 syntax corrections
- **semantic**: + naming, comments, clarity
- **full**: + expansion, error handling

## Rules Reference

The agent MUST follow all rules from:
- `data/Scripts/AGENTS.md` (primary)
- `docs/dataset_guidelines.md` (curation)
- `ahk_formatting_spec.md` (formatting)

## Response Format

When fixing a script, provide:
1. **Issues Found**: List each rule violation with line numbers
2. **Fixed Script**: Complete corrected code
3. **Changes Made**: Summary of each change
