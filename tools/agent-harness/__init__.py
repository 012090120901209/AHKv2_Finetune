"""
AHK Agent Harness - AI-powered script validation and fixing

This package provides tools for validating and fixing AutoHotkey v2 example
scripts based on rules defined in AGENTS.md and related documentation.

Components:
    - RulesEngine: Parse documentation into structured validation rules
    - AHKFixerAgent: Batch process scripts using Claude API
    - CLI: Command-line interface for both

Usage:
    # CLI
    python -m agent-harness fix data/Scripts/ --recursive
    python -m agent-harness validate data/Scripts/script.ahk

    # Python API
    from agent_harness import RulesEngine, AHKFixerAgent

    engine = RulesEngine(project_root)
    engine.load_all_rules()
    issues = engine.validate_script_quick(script_content)
"""

from .rules_engine import RulesEngine, Rule, RuleSet, RuleSeverity, RuleCategory
from .agent import AHKFixerAgent, FixLevel, ScriptAnalysis, BatchReport

__version__ = "1.0.0"
__all__ = [
    "RulesEngine",
    "Rule",
    "RuleSet",
    "RuleSeverity",
    "RuleCategory",
    "AHKFixerAgent",
    "FixLevel",
    "ScriptAnalysis",
    "BatchReport",
]
