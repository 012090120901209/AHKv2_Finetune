#!/usr/bin/env python3
"""
Test suite for the AHK Agent Harness
"""

import sys
from pathlib import Path

# Add parent to path for imports
sys.path.insert(0, str(Path(__file__).parent))

from rules_engine import RulesEngine, RuleSeverity, RuleCategory


def test_rules_engine():
    """Test the rules engine loads and validates correctly"""
    print("Testing Rules Engine...")

    project_root = Path(__file__).parent.parent.parent
    engine = RulesEngine(project_root)
    engine.load_all_rules()

    # Check rules loaded
    all_rules = engine.get_all_rules()
    required_rules = engine.get_required_rules()

    print(f"  Total rules loaded: {len(all_rules)}")
    print(f"  Required rules: {len(required_rules)}")

    assert len(all_rules) > 0, "No rules loaded"
    assert len(required_rules) > 0, "No required rules loaded"

    # Test validation on good script
    good_script = '''#Requires AutoHotkey v2.0
#SingleInstance Force

; This example demonstrates a simple counter
counter := 0

^j:: {
    global counter
    counter++
    MsgBox("Counter: " counter)
}
'''

    issues = engine.validate_script_quick(good_script)
    print(f"  Good script issues: {len(issues)}")

    # Test validation on bad script
    bad_script = '''
; Missing #Requires
MsgBox, Hello World  ; v1 syntax
'''

    issues = engine.validate_script_quick(bad_script)
    print(f"  Bad script issues: {len(issues)}")
    assert len(issues) > 0, "Bad script should have issues"

    print("  Rules Engine: PASSED")
    return True


def test_quick_validation():
    """Test quick validation patterns"""
    print("Testing Quick Validation...")

    project_root = Path(__file__).parent.parent.parent
    engine = RulesEngine(project_root)
    engine.load_all_rules()

    # Test v1 syntax detection
    v1_examples = [
        ("MsgBox, Hello", "v1 MsgBox"),
        ("Gui, Add, Button", "v1 Gui"),
        ("StringReplace, out, in, old, new", "v1 StringReplace"),
    ]

    for code, desc in v1_examples:
        script = f"#Requires AutoHotkey v2.0\n{code}"
        issues = engine.validate_script_quick(script)
        found_v1 = any("v1" in str(i.get("message", "")).lower() or
                       "syntax" in str(i.get("message", "")).lower()
                       for i in issues)
        status = "OK" if found_v1 else "MISSED"
        print(f"  {desc}: {status}")

    print("  Quick Validation: PASSED")
    return True


def test_system_prompt():
    """Test system prompt generation"""
    print("Testing System Prompt Generation...")

    project_root = Path(__file__).parent.parent.parent
    engine = RulesEngine(project_root)
    engine.load_all_rules()

    prompt = engine.generate_system_prompt()

    assert len(prompt) > 1000, "System prompt too short"
    assert "#Requires" in prompt, "Missing #Requires in prompt"
    assert "v2" in prompt.lower(), "Missing v2 reference in prompt"

    print(f"  System prompt length: {len(prompt)} chars")
    print("  System Prompt Generation: PASSED")
    return True


def main():
    """Run all tests"""
    print("=" * 60)
    print("AHK Agent Harness Test Suite")
    print("=" * 60)
    print()

    tests = [
        test_rules_engine,
        test_quick_validation,
        test_system_prompt,
    ]

    passed = 0
    failed = 0

    for test in tests:
        try:
            if test():
                passed += 1
        except Exception as e:
            print(f"  FAILED: {e}")
            failed += 1
        print()

    print("=" * 60)
    print(f"Results: {passed} passed, {failed} failed")
    print("=" * 60)

    return failed == 0


if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
