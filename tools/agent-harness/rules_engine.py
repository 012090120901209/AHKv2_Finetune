"""
Rules Engine - Parse AGENTS.md and docs into structured validation rules

This module extracts actionable rules from documentation files
and provides them in a format suitable for AI agent processing.
"""

import re
from pathlib import Path
from dataclasses import dataclass, field
from typing import Optional
from enum import Enum


class RuleSeverity(Enum):
    REQUIRED = "required"       # Must be fixed
    RECOMMENDED = "recommended" # Should be fixed
    OPTIONAL = "optional"       # Nice to have


class RuleCategory(Enum):
    HEADER = "header"           # File header requirements
    SYNTAX = "syntax"           # AHK v2 syntax rules
    NAMING = "naming"           # File/function naming conventions
    COMMENTS = "comments"       # Comment formatting
    ENCODING = "encoding"       # File encoding rules
    STRUCTURE = "structure"     # Code structure requirements
    DEPENDENCIES = "dependencies" # Include/dependency rules


@dataclass
class Rule:
    """Represents a single validation rule"""
    id: str
    title: str
    description: str
    category: RuleCategory
    severity: RuleSeverity
    examples_good: list[str] = field(default_factory=list)
    examples_bad: list[str] = field(default_factory=list)
    regex_pattern: Optional[str] = None
    fix_template: Optional[str] = None

    def to_prompt(self) -> str:
        """Convert rule to a prompt fragment for the AI agent"""
        parts = [f"## Rule: {self.title}"]
        parts.append(f"**Severity:** {self.severity.value}")
        parts.append(f"**Category:** {self.category.value}")
        parts.append(f"\n{self.description}")

        if self.examples_good:
            parts.append("\n**Correct examples:**")
            for ex in self.examples_good:
                parts.append(f"```ahk\n{ex}\n```")

        if self.examples_bad:
            parts.append("\n**Incorrect examples (avoid):**")
            for ex in self.examples_bad:
                parts.append(f"```ahk\n{ex}\n```")

        return "\n".join(parts)


@dataclass
class RuleSet:
    """Collection of rules with metadata"""
    name: str
    source_file: str
    rules: list[Rule] = field(default_factory=list)

    def get_rules_by_category(self, category: RuleCategory) -> list[Rule]:
        return [r for r in self.rules if r.category == category]

    def get_required_rules(self) -> list[Rule]:
        return [r for r in self.rules if r.severity == RuleSeverity.REQUIRED]

    def to_system_prompt(self) -> str:
        """Generate a system prompt containing all rules"""
        parts = [f"# {self.name}\n"]
        parts.append(f"Source: {self.source_file}\n")

        # Group by category
        for category in RuleCategory:
            cat_rules = self.get_rules_by_category(category)
            if cat_rules:
                parts.append(f"\n## {category.value.title()} Rules\n")
                for rule in cat_rules:
                    parts.append(rule.to_prompt())
                    parts.append("")

        return "\n".join(parts)


class RulesParser:
    """Parse markdown documentation into structured rules"""

    def __init__(self, docs_root: Path):
        self.docs_root = Path(docs_root)
        self.rules: list[Rule] = []

    def parse_agents_md(self, filepath: Path) -> RuleSet:
        """Parse the main AGENTS.md file"""
        content = filepath.read_text(encoding='utf-8')
        ruleset = RuleSet(
            name="AutoHotkey v2 Example Rules",
            source_file=str(filepath)
        )

        # Extract required rules (### numbered sections under ## Required)
        ruleset.rules.extend(self._parse_required_section(content))

        # Extract strong conventions
        ruleset.rules.extend(self._parse_conventions_section(content))

        return ruleset

    def _parse_required_section(self, content: str) -> list[Rule]:
        """Extract rules from the ## Required section"""
        rules = []

        # Rule 1: v2 header directive
        rules.append(Rule(
            id="header-requires",
            title="v2 Header Directive Required",
            description="Every file MUST include a #Requires line for v2. If the example depends on a newer v2.1-alpha feature, bump the version accordingly.",
            category=RuleCategory.HEADER,
            severity=RuleSeverity.REQUIRED,
            examples_good=["#Requires AutoHotkey v2.0"],
            examples_bad=["#Requires AutoHotkey v1.1", "(missing #Requires directive)"],
            regex_pattern=r'^#Requires\s+AutoHotkey\s+v2',
            fix_template="#Requires AutoHotkey v2.0"
        ))

        # Rule 2: SingleInstance
        rules.append(Rule(
            id="header-singleinstance",
            title="SingleInstance Force Recommended",
            description="Examples SHOULD include #SingleInstance Force. If omitted, document why in the file header (e.g., demonstrates multi-instance behavior).",
            category=RuleCategory.HEADER,
            severity=RuleSeverity.RECOMMENDED,
            examples_good=["#SingleInstance Force"],
            examples_bad=["#SingleInstance Off  ; (without explanation)"],
            regex_pattern=r'^#SingleInstance\s+Force',
            fix_template="#SingleInstance Force"
        ))

        # Rule 3: Clear description
        rules.append(Rule(
            id="header-description",
            title="Clear Description at Top",
            description="Every file MUST explain what it demonstrates near the top. Use either a one-line ; comment (simple examples) or a short /** */ doc block (larger examples). Keep it factual and task-centric.",
            category=RuleCategory.COMMENTS,
            severity=RuleSeverity.REQUIRED,
            examples_good=[
                "; Demonstrates array chunking with configurable size",
                '/**\n * Event emitter pattern implementation\n * Supports multiple listeners per event\n */'
            ],
            examples_bad=[
                "; converter test",
                "; issue #123",
                "(no description)"
            ]
        ))

        # Rule 4: Pure AHK v2 syntax
        rules.append(Rule(
            id="syntax-v2-pure",
            title="Pure AHK v2 Syntax",
            description="Examples MUST be valid AutoHotkey v2 (expression-based) code. No v1 command syntax. Use parentheses for calls. Keep hotkeys/GUI/callbacks idiomatic for v2.",
            category=RuleCategory.SYNTAX,
            severity=RuleSeverity.REQUIRED,
            examples_good=[
                'MsgBox("Hello")',
                'result := MyFunc(arg1, arg2)',
                'myGui := Gui()'
            ],
            examples_bad=[
                'MsgBox, Hello',
                'Gui, Add, Button',
                'StringReplace, output, input, old, new'
            ]
        ))

        # Rule 5: Standalone or explicit dependencies
        rules.append(Rule(
            id="deps-explicit",
            title="Standalone or Explicit Dependencies",
            description="Examples MUST be runnable as-written OR clearly declare dependencies. Prefer self-contained examples. If you need a library, use #Include near the top.",
            category=RuleCategory.DEPENDENCIES,
            severity=RuleSeverity.REQUIRED,
            examples_good=[
                '#Include ../Lib/JSON.ahk\n; Uses JSON library for parsing'
            ],
            examples_bad=[
                '; Requires SomeLib (not included)',
                '(calls undefined functions)'
            ]
        ))

        return rules

    def _parse_conventions_section(self, content: str) -> list[Rule]:
        """Extract rules from the ## Strong conventions section"""
        rules = []

        # Naming conventions
        rules.append(Rule(
            id="naming-descriptive",
            title="Descriptive File Names",
            description="File names SHOULD be descriptive and task-centric. Use patterns like [Category]_[Number]_[Description].ahk or [Category]_[Feature]_[Detail].ahk. Use numerals only for true variants.",
            category=RuleCategory.NAMING,
            severity=RuleSeverity.RECOMMENDED,
            examples_good=[
                "Array_01_Chunk.ahk",
                "Advanced_Class_EventEmitter.ahk",
                "GUI_ListView_Sorting.ahk"
            ],
            examples_bad=[
                "test.ahk",
                "V1toV2_converted.ahk",
                "Issue_123_fix.ahk"
            ]
        ))

        # Comment style
        rules.append(Rule(
            id="comments-educational",
            title="Educational but Tight Comments",
            description="Keep comments educational but tight: explain behavior, inputs, and edge cases. For multi-line explanations, prefer bullet-like ; - lines.",
            category=RuleCategory.COMMENTS,
            severity=RuleSeverity.RECOMMENDED,
            examples_good=[
                "; - Handles empty arrays gracefully\n; - Returns new array, doesn't modify original",
                "; Chunks array into groups of specified size"
            ],
            examples_bad=[
                "; This is a really long comment that goes on and on about things that are obvious from the code itself and doesn't add value",
                "; TODO: fix this later"
            ]
        ))

        # No hardcoded paths
        rules.append(Rule(
            id="content-no-hardcoded",
            title="No Hardcoded Personal Data",
            description="Avoid hardcoded machine-specific paths, credentials, or personal data.",
            category=RuleCategory.STRUCTURE,
            severity=RuleSeverity.RECOMMENDED,
            examples_good=[
                'configPath := A_ScriptDir "\\config.ini"',
                'userDir := A_MyDocuments'
            ],
            examples_bad=[
                'path := "C:\\Users\\JohnDoe\\Documents\\file.txt"',
                'apiKey := "sk-1234567890abcdef"'
            ]
        ))

        # Encoding
        rules.append(Rule(
            id="encoding-utf8",
            title="UTF-8 Without BOM",
            description="Save files as UTF-8 without BOM.",
            category=RuleCategory.ENCODING,
            severity=RuleSeverity.RECOMMENDED
        ))

        return rules

    def parse_dataset_guidelines(self, filepath: Path) -> RuleSet:
        """Parse docs/dataset_guidelines.md for additional rules"""
        content = filepath.read_text(encoding='utf-8')
        ruleset = RuleSet(
            name="Dataset Curation Guidelines",
            source_file=str(filepath)
        )

        # Function/label naming
        ruleset.rules.append(Rule(
            id="naming-semantic",
            title="Semantically Meaningful Names",
            description="Function and label names should be semantically meaningful. Remove converter artifacts. Use verbs for functions and labels.",
            category=RuleCategory.NAMING,
            severity=RuleSeverity.RECOMMENDED,
            examples_good=[
                "InitGlobalState()",
                "HandleHotkey()",
                "StartLoop:",
                "ProcessData()"
            ],
            examples_bad=[
                "Func1()",
                "sub_1234:",
                "converted_routine()"
            ]
        ))

        # No conversion artifacts
        ruleset.rules.append(Rule(
            id="content-no-artifacts",
            title="Remove Conversion Artifacts",
            description="Remove references to V1toV2, Issue numbers, stress tests, or converter language from filenames and content.",
            category=RuleCategory.STRUCTURE,
            severity=RuleSeverity.REQUIRED,
            regex_pattern=r'(V1toV2|Issue\s*#?\d+|Stress\s*Test|converter)',
            examples_bad=[
                "; Converted from V1 using converter",
                "; Issue #123 - bug fix",
                "V1toV2_Migration.ahk"
            ]
        ))

        # Minimal examples
        ruleset.rules.append(Rule(
            id="content-minimal",
            title="Preserve Minimal Examples",
            description="Remove redundant MsgBox/Sleep calls. Ensure idiomatic AHK v2 usage. Remove conversion scaffolding.",
            category=RuleCategory.STRUCTURE,
            severity=RuleSeverity.RECOMMENDED,
            examples_bad=[
                'Sleep(1000)  ; (unnecessary delay)',
                'MsgBox("Debug: " var)  ; (debug leftover)'
            ]
        ))

        return ruleset


class RulesEngine:
    """Main interface for the rules engine"""

    def __init__(self, project_root: Path):
        self.project_root = Path(project_root)
        self.parser = RulesParser(project_root)
        self.rulesets: list[RuleSet] = []

    def load_all_rules(self) -> None:
        """Load rules from all documentation files"""
        # AGENTS.md in data/Scripts
        agents_md = self.project_root / "data" / "Scripts" / "AGENTS.md"
        if agents_md.exists():
            self.rulesets.append(self.parser.parse_agents_md(agents_md))

        # dataset_guidelines.md in docs
        guidelines = self.project_root / "docs" / "dataset_guidelines.md"
        if guidelines.exists():
            self.rulesets.append(self.parser.parse_dataset_guidelines(guidelines))

    def get_all_rules(self) -> list[Rule]:
        """Get all rules from all rulesets"""
        rules = []
        for rs in self.rulesets:
            rules.extend(rs.rules)
        return rules

    def get_required_rules(self) -> list[Rule]:
        """Get only required rules"""
        return [r for r in self.get_all_rules() if r.severity == RuleSeverity.REQUIRED]

    def generate_system_prompt(self) -> str:
        """Generate a complete system prompt with all rules"""
        parts = ["# AHK v2 Example Validation Rules\n"]
        parts.append("You are an expert AutoHotkey v2 developer tasked with validating and fixing example scripts.\n")
        parts.append("Apply the following rules when analyzing scripts:\n")

        for ruleset in self.rulesets:
            parts.append(ruleset.to_system_prompt())

        return "\n".join(parts)

    def generate_fix_prompt(self, script_content: str, diagnostics: list[dict]) -> str:
        """Generate a prompt for fixing a specific script"""
        prompt_parts = [
            "# Script Analysis Request\n",
            "## Current Script Content\n",
            "```ahk",
            script_content,
            "```\n",
        ]

        if diagnostics:
            prompt_parts.append("## LSP Diagnostics Found\n")
            for d in diagnostics:
                prompt_parts.append(f"- Line {d.get('line', '?')}: {d.get('message', 'Unknown issue')} [{d.get('severity', 'error')}]")
            prompt_parts.append("")

        prompt_parts.extend([
            "## Task\n",
            "1. Analyze the script against all rules",
            "2. Identify all violations",
            "3. Provide a corrected version of the script",
            "4. Explain what was changed and why\n",
            "## Response Format\n",
            "Provide your response as:",
            "1. **Issues Found**: List each rule violation",
            "2. **Corrected Script**: The fixed AHK code in a code block",
            "3. **Changes Made**: Brief explanation of each fix"
        ])

        return "\n".join(prompt_parts)

    def validate_script_quick(self, content: str) -> list[dict]:
        """Quick regex-based validation without LSP"""
        issues = []
        lines = content.split('\n')

        for rule in self.get_all_rules():
            if rule.regex_pattern:
                pattern = re.compile(rule.regex_pattern, re.MULTILINE)
                if rule.id.startswith("header-"):
                    # Header rules should match
                    if not pattern.search(content):
                        issues.append({
                            "rule_id": rule.id,
                            "title": rule.title,
                            "severity": rule.severity.value,
                            "message": f"Missing required element: {rule.title}",
                            "fix_template": rule.fix_template
                        })
                elif "no-" in rule.id or "artifacts" in rule.id:
                    # Negative rules - should NOT match
                    match = pattern.search(content)
                    if match:
                        issues.append({
                            "rule_id": rule.id,
                            "title": rule.title,
                            "severity": rule.severity.value,
                            "message": f"Found prohibited content: {match.group()}",
                            "line": content[:match.start()].count('\n') + 1
                        })

        # Check for v1 syntax patterns
        v1_patterns = [
            (r'^(\s*)MsgBox\s*,', "v1 MsgBox syntax"),
            (r'^(\s*)Gui\s*,', "v1 Gui syntax"),
            (r'^(\s*)StringReplace\s*,', "v1 StringReplace command"),
            (r'^(\s*)IfEqual\s*,', "v1 IfEqual syntax"),
            (r'^(\s*)SetEnv\s*,', "v1 SetEnv command"),
            (r'(\w+)\s*=\s*[^=]', "Possible v1 assignment (should use :=)"),
        ]

        for i, line in enumerate(lines, 1):
            for pattern, desc in v1_patterns:
                if re.match(pattern, line, re.IGNORECASE):
                    issues.append({
                        "rule_id": "syntax-v2-pure",
                        "title": "Pure AHK v2 Syntax",
                        "severity": "required",
                        "message": f"Detected {desc}",
                        "line": i
                    })

        return issues


def main():
    """CLI for testing the rules engine"""
    import sys
    import json

    project_root = Path(__file__).parent.parent.parent
    engine = RulesEngine(project_root)
    engine.load_all_rules()

    if len(sys.argv) > 1:
        cmd = sys.argv[1]

        if cmd == "list":
            # List all rules
            for rule in engine.get_all_rules():
                print(f"[{rule.severity.value}] {rule.id}: {rule.title}")

        elif cmd == "prompt":
            # Print system prompt
            print(engine.generate_system_prompt())

        elif cmd == "validate" and len(sys.argv) > 2:
            # Validate a script file
            filepath = Path(sys.argv[2])
            if filepath.exists():
                content = filepath.read_text(encoding='utf-8')
                issues = engine.validate_script_quick(content)
                print(json.dumps(issues, indent=2))
            else:
                print(f"File not found: {filepath}")

        else:
            print("Usage:")
            print("  python rules_engine.py list          - List all rules")
            print("  python rules_engine.py prompt        - Show system prompt")
            print("  python rules_engine.py validate FILE - Validate a script")
    else:
        print(f"Loaded {len(engine.get_all_rules())} rules from {len(engine.rulesets)} rulesets")
        print(f"Required rules: {len(engine.get_required_rules())}")


if __name__ == "__main__":
    main()
