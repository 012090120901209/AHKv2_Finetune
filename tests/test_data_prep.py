"""Unit tests for src/data_prep.py"""

import json
import tempfile
import unittest
from pathlib import Path

import sys
sys.path.insert(0, str(Path(__file__).parent.parent))

from src.data_prep import to_harmony


class TestToHarmony(unittest.TestCase):
    """Tests for the to_harmony function."""

    def test_basic_conversion(self):
        """Test basic prompt/response conversion to Harmony format."""
        prompt = "Write a hello world script"
        response = 'MsgBox("Hello World")'

        result = to_harmony(prompt, response)

        self.assertEqual(len(result["messages"]), 3)
        self.assertEqual(result["messages"][0]["role"], "system")
        self.assertEqual(result["messages"][1]["role"], "user")
        self.assertEqual(result["messages"][2]["role"], "assistant")
        self.assertEqual(result["messages"][1]["content"], prompt)
        self.assertEqual(result["messages"][2]["content"], response)

    def test_strips_whitespace(self):
        """Test that prompt and response are stripped of whitespace."""
        prompt = "  Write a script  \n"
        response = "\n  MsgBox('test')  \n"

        result = to_harmony(prompt, response)

        self.assertEqual(result["messages"][1]["content"], "Write a script")
        self.assertEqual(result["messages"][2]["content"], "MsgBox('test')")

    def test_preserves_internal_whitespace(self):
        """Test that internal whitespace is preserved."""
        prompt = "Write a\nmultiline\nprompt"
        response = "MsgBox('line 1')\nMsgBox('line 2')"

        result = to_harmony(prompt, response)

        self.assertIn("\n", result["messages"][1]["content"])
        self.assertIn("\n", result["messages"][2]["content"])

    def test_system_message_content(self):
        """Test that system message has correct content."""
        result = to_harmony("test", "test")

        system_content = result["messages"][0]["content"]
        self.assertIn("helpful assistant", system_content.lower())

    def test_empty_strings(self):
        """Test handling of empty strings."""
        result = to_harmony("", "")

        self.assertEqual(result["messages"][1]["content"], "")
        self.assertEqual(result["messages"][2]["content"], "")


class TestDataPrepIntegration(unittest.TestCase):
    """Integration tests for the full data_prep pipeline."""

    def test_end_to_end_conversion(self):
        """Test end-to-end JSONL conversion."""
        # Create temporary input and output files
        with tempfile.TemporaryDirectory() as tmpdir:
            input_file = Path(tmpdir) / "input.jsonl"
            output_file = Path(tmpdir) / "output.jsonl"

            # Write test input data
            test_data = [
                {"prompt": "Test prompt 1", "response": "Test response 1", "metadata": {}},
                {"prompt": "Test prompt 2", "response": "Test response 2", "metadata": {}},
            ]

            with open(input_file, "w", encoding="utf-8") as f:
                for item in test_data:
                    f.write(json.dumps(item, ensure_ascii=False) + "\n")

            # Run conversion
            from src.data_prep import main
            sys.argv = ["data_prep.py", "--in", str(input_file), "--out", str(output_file)]
            main()

            # Verify output
            self.assertTrue(output_file.exists())

            with open(output_file, "r", encoding="utf-8") as f:
                lines = f.readlines()

            self.assertEqual(len(lines), 2)

            # Check first converted record
            record1 = json.loads(lines[0])
            self.assertIn("messages", record1)
            self.assertEqual(len(record1["messages"]), 3)
            self.assertEqual(record1["messages"][1]["content"], "Test prompt 1")
            self.assertEqual(record1["messages"][2]["content"], "Test response 1")

    def test_skips_empty_lines(self):
        """Test that empty lines in input are skipped."""
        with tempfile.TemporaryDirectory() as tmpdir:
            input_file = Path(tmpdir) / "input.jsonl"
            output_file = Path(tmpdir) / "output.jsonl"

            # Write input with empty lines
            with open(input_file, "w", encoding="utf-8") as f:
                f.write('{"prompt": "Test 1", "response": "Response 1"}\n')
                f.write('\n')  # Empty line
                f.write('   \n')  # Whitespace only line
                f.write('{"prompt": "Test 2", "response": "Response 2"}\n')

            # Run conversion
            from src.data_prep import main
            sys.argv = ["data_prep.py", "--in", str(input_file), "--out", str(output_file)]
            main()

            # Should only have 2 output lines, not 4
            with open(output_file, "r", encoding="utf-8") as f:
                lines = [l for l in f.readlines() if l.strip()]

            self.assertEqual(len(lines), 2)


if __name__ == "__main__":
    unittest.main()
