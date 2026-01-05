# AHK Generator Agent

Use this agent to generate new AutoHotkey v2 example scripts that follow all rules and conventions.

## Purpose

Create high-quality AHK v2 examples suitable for fine-tuning datasets.

## Capabilities

- Generate new examples from descriptions
- Expand incomplete or stub examples
- Create variations of existing examples
- Generate examples for specific categories
- Ensure all output follows AGENTS.md rules

## Workflow

1. Understand the requested example type/topic
2. Review existing examples in the target category for consistency
3. Generate the example following all rules
4. Self-validate against rules engine
5. Output the complete, ready-to-use script

## Tools Available

- Read: Read existing examples and rules
- Write: Create new example files
- Glob: Find related examples
- Bash: Run validation

## Usage Examples

```
Generate a new Array example that demonstrates the Zip function
```

```
Create 3 variations of the EventEmitter pattern with different use cases
```

```
Expand this stub into a complete example: [partial code]
```

## Required Output Format

Every generated script MUST include:

```ahk
#Requires AutoHotkey v2.0
#SingleInstance Force

; [Clear description of what this example demonstrates]
; - Key feature 1
; - Key feature 2

; [Implementation code...]

; [Usage example or demonstration...]
```

## Categories Available

Reference `data/Scripts/` for the full list:
- Advanced/ - Design patterns, complex implementations
- Alpha/ - Cutting-edge features, data structures
- Array/ - Array manipulation functions
- BuiltIn/ - Built-in function demonstrations
- Control/ - Control flow structures
- DateTime/ - Date/time operations
- File/ - File operations
- GUI/ - GUI creation
- Hotkey/ - Hotkey definitions
- Hotstring/ - Hotstring replacements
- And more...

## Naming Convention

Use these patterns:
- `[Category]_[Number]_[Description].ahk` (e.g., `Array_33_Partition.ahk`)
- `[Category]_[Feature]_[Detail].ahk` (e.g., `Advanced_Class_Singleton.ahk`)

## Quality Checklist

Before outputting, verify:
- [ ] #Requires AutoHotkey v2.0 present
- [ ] #SingleInstance Force present (or documented why not)
- [ ] Clear description at top
- [ ] Pure v2 syntax throughout
- [ ] Educational comments (not excessive)
- [ ] No hardcoded paths or credentials
- [ ] Standalone or explicit #Include
- [ ] Descriptive variable/function names
- [ ] Example demonstrates clear use case
