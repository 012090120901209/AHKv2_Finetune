# AHK Finetune - Development Guidelines

## Project Overview

This repository contains a fine-tuning dataset infrastructure for AutoHotkey v2 examples. It includes ~1,873 AHK v2 example scripts, validation tooling, and dataset preparation workflows.

## Agent Harness

The project includes an AI-powered agent harness for validating and fixing example scripts.

### Available Agents

Use these with the Task tool:

1. **ahk-fixer** - Fix scripts based on AGENTS.md rules
   - Formatting, syntax, semantic, and full rewrites
   - Example: `Task("Fix data/Scripts/Advanced/Advanced_GUI_Calculator.ahk", subagent_type="ahk-fixer")`

2. **ahk-linter** - Analyze scripts without modifications
   - Generate problems reports
   - Example: `Task("Analyze all scripts in data/Scripts/Array/", subagent_type="ahk-linter")`

3. **ahk-generator** - Create new example scripts
   - Generate high-quality training examples
   - Example: `Task("Generate Array example for Partition function", subagent_type="ahk-generator")`

### CLI Tools

```bash
# Python agent (batch mode)
python tools/agent-harness/agent.py fix data/Scripts/ --recursive --level=full

# Quick validation (no AI)
python tools/agent-harness/agent.py validate data/Scripts/script.ahk

# Rules engine
python tools/agent-harness/rules_engine.py list     # List all rules
python tools/agent-harness/rules_engine.py prompt   # Show system prompt

# Existing formatter
python scripts/format_ahk_examples.py --root data/Scripts --check
python scripts/format_ahk_examples.py --root data/Scripts --fix --thqby
```

### LSP Linter (Node.js)

```bash
cd tools/ahk-linter
npm install
npx ts-node index.ts lint path=../../data/Scripts/script.ahk
npx ts-node index.ts lint path=../../data/Scripts --recursive --format=json
```

## Example Rules

All scripts MUST follow rules from `data/Scripts/AGENTS.md`:

### Required
- `#Requires AutoHotkey v2.0` header
- `#SingleInstance Force` (unless documented otherwise)
- Clear description at top
- Pure AHK v2 syntax (no v1 commands)
- Standalone or explicit `#Include` dependencies

### Conventions
- Descriptive file names: `[Category]_[Feature].ahk`
- Educational but tight comments
- No hardcoded paths/credentials
- UTF-8 without BOM

## Directory Structure

```
ahk-finetune/
├── data/
│   ├── Scripts/           # Example scripts (~1,873 files)
│   │   ├── Advanced/
│   │   ├── Alpha/
│   │   ├── Array/
│   │   ├── BuiltIn/
│   │   └── AGENTS.md      # Primary rules document
│   └── prepared/          # Dataset splits (train/val/test)
├── docs/                  # Documentation
├── scripts/               # Existing tooling
├── tools/
│   ├── agent-harness/     # AI agent harness
│   │   ├── agent.py       # Main CLI agent
│   │   └── rules_engine.py # Rules parser
│   └── ahk-linter/        # Node.js LSP linter
├── vscode-autohotkey2-lsp/ # THQBY LSP (submodule)
└── config/
    └── sft.yaml           # Training config
```

## Common Commands

```bash
# Setup
pip install anthropic      # For AI agent
cd tools/ahk-linter && npm install

# Validate
python tools/agent-harness/agent.py validate data/Scripts/

# Fix with AI
export ANTHROPIC_API_KEY=your-key
python tools/agent-harness/agent.py fix data/Scripts/ -r --level=semantic

# Format check
python scripts/format_ahk_examples.py --root data/Scripts --check
```

## AutoHotkey v2 Quick Reference

```ahk
#Requires AutoHotkey v2.0
#SingleInstance Force

; Use := for assignment (not =)
myVar := "value"

; Use function syntax (not commands)
MsgBox("Hello")  ; NOT: MsgBox, Hello

; GUI is object-based
myGui := Gui()
myGui.Add("Button", "w200", "Click Me")
myGui.Show()

; Arrays are 1-indexed
arr := [1, 2, 3]
first := arr[1]  ; NOT arr[0]
```
