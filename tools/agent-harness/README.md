# AHK Agent Harness

AI-powered validation and fixing of AutoHotkey v2 example scripts.

## Features

- **Rules Engine**: Parses `AGENTS.md` and documentation into structured validation rules
- **Quick Validation**: Regex-based checks for common issues
- **AI-Powered Fixes**: Uses Claude API to intelligently fix scripts
- **Batch Processing**: Process entire directories with progress tracking
- **Multiple Fix Levels**: From formatting-only to full semantic rewrites

## Installation

```bash
cd tools/agent-harness
pip install -r requirements.txt

# For AI-powered fixes, set your API key
export ANTHROPIC_API_KEY=your-key
```

## CLI Usage

### Validate Scripts (Quick, No AI)

```bash
# Single file
python agent.py validate data/Scripts/Advanced/Advanced_GUI_Calculator.ahk

# Multiple files
python agent.py validate data/Scripts/Array/*.ahk
```

### Analyze Scripts (With AI)

```bash
# Generate detailed report without making changes
python agent.py analyze data/Scripts/Advanced/ --recursive --output report.json
```

### Fix Scripts (With AI)

```bash
# Fix single file
python agent.py fix data/Scripts/script.ahk

# Fix directory recursively
python agent.py fix data/Scripts/ --recursive

# Dry run (don't write changes)
python agent.py fix data/Scripts/ --recursive --dry-run

# Specify fix level
python agent.py fix data/Scripts/ --level=formatting  # Headers/whitespace only
python agent.py fix data/Scripts/ --level=syntax      # + v1→v2 conversion
python agent.py fix data/Scripts/ --level=semantic    # + naming/comments
python agent.py fix data/Scripts/ --level=full        # Everything
```

### Rules Engine Standalone

```bash
# List all rules
python rules_engine.py list

# Show system prompt (for use with Claude)
python rules_engine.py prompt

# Validate a script
python rules_engine.py validate data/Scripts/script.ahk
```

## Python API

```python
from pathlib import Path
from rules_engine import RulesEngine
from agent import AHKFixerAgent, FixLevel

# Initialize
project_root = Path("/path/to/ahk-finetune")
engine = RulesEngine(project_root)
engine.load_all_rules()

# Quick validation (no AI)
content = Path("script.ahk").read_text()
issues = engine.validate_script_quick(content)

# AI-powered fixing
agent = AHKFixerAgent(
    project_root=project_root,
    fix_level=FixLevel.FULL,
    dry_run=True
)
report = agent.process_batch([Path("data/Scripts/")], recursive=True, apply_fixes=True)
```

## Fix Levels

| Level | What It Fixes |
|-------|---------------|
| `formatting` | Headers, whitespace, encoding, #Requires directive |
| `syntax` | + v1→v2 syntax, function calls, assignment operators |
| `semantic` | + Variable naming, comments, removing artifacts |
| `full` | + Expand incomplete examples, add error handling |

## Rules Checked

### Required (MUST fix)
- `#Requires AutoHotkey v2.0` header present
- Pure AHK v2 syntax (no v1 commands)
- Clear description at top of file
- Standalone or explicit dependencies

### Recommended (SHOULD fix)
- `#SingleInstance Force` present
- Descriptive file names
- Educational but tight comments
- UTF-8 without BOM
- No hardcoded paths/credentials

## Output Formats

### JSON Report
```json
{
  "summary": {
    "total_files": 100,
    "files_fixed": 15,
    "total_errors": 23
  },
  "files": [
    {
      "file_path": "script.ahk",
      "status": "fixed",
      "changes_made": ["Added #Requires header", "Converted MsgBox syntax"]
    }
  ]
}
```

## Integration with Claude Code

The agent harness includes custom agent definitions for use with Claude Code's Task tool:

```
Task("Fix data/Scripts/script.ahk", subagent_type="ahk-fixer")
Task("Analyze data/Scripts/Array/", subagent_type="ahk-linter")
Task("Generate new Array example", subagent_type="ahk-generator")
```

See `.claude/agents/` for agent definitions.

## Architecture

```
tools/agent-harness/
├── agent.py          # Main CLI and AHKFixerAgent class
├── rules_engine.py   # Rules parser and validator
├── requirements.txt  # Python dependencies
└── README.md         # This file

.claude/
├── agents/
│   ├── ahk-fixer.md      # Fixer agent definition
│   ├── ahk-linter.md     # Linter agent definition
│   └── ahk-generator.md  # Generator agent definition
└── settings.json         # Agent configuration
```
