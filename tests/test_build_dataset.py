"""Unit tests for src/build_dataset.py"""

import hashlib
import json
import tempfile
import unittest
from pathlib import Path

import sys
sys.path.insert(0, str(Path(__file__).parent.parent))

from src.build_dataset import (
    humanise_title,
    build_prompt,
    iterate_snippets,
    iterate_reference_elements,
    dedupe,
    split_records,
    SnippetRecord,
)


class TestHumaniseTitle(unittest.TestCase):
    """Tests for humanise_title function."""

    def test_underscores_to_spaces(self):
        """Test that underscores are converted to spaces."""
        self.assertEqual(humanise_title("File_Read_Example"), "File Read Example")

    def test_hyphens_to_spaces(self):
        """Test that hyphens are converted to spaces."""
        self.assertEqual(humanise_title("my-test-file"), "my test file")

    def test_multiple_spaces_collapsed(self):
        """Test that multiple spaces are collapsed to one."""
        self.assertEqual(humanise_title("test__multiple___spaces"), "test multiple spaces")

    def test_strips_whitespace(self):
        """Test that leading/trailing whitespace is stripped."""
        self.assertEqual(humanise_title("  test_file  "), "test file")

    def test_mixed_separators(self):
        """Test handling of mixed underscores and hyphens."""
        self.assertEqual(humanise_title("test_file-name_here"), "test file name here")


class TestBuildPrompt(unittest.TestCase):
    """Tests for build_prompt function."""

    def test_contains_all_fields(self):
        """Test that prompt contains all required fields."""
        prompt = build_prompt("GUI", "Button_Click", "GUI/Button_Click.ahk")

        self.assertIn("GUI", prompt)
        self.assertIn("Button_Click", prompt)
        self.assertIn("GUI/Button_Click.ahk", prompt)
        self.assertIn("Category:", prompt)
        self.assertIn("Example ID:", prompt)
        self.assertIn("Source Path:", prompt)

    def test_multiline_format(self):
        """Test that prompt is multiline."""
        prompt = build_prompt("Test", "test_id", "test/path")

        self.assertIn("\n", prompt)
        lines = prompt.split("\n")
        self.assertGreater(len(lines), 3)


class TestIterateSnippets(unittest.TestCase):
    """Tests for iterate_snippets function."""

    def setUp(self):
        """Create temporary directory with test files."""
        self.tmpdir = tempfile.TemporaryDirectory()
        self.root = Path(self.tmpdir.name)

    def tearDown(self):
        """Clean up temporary directory."""
        self.tmpdir.cleanup()

    def test_finds_ahk_files(self):
        """Test that .ahk files are found."""
        # Create test .ahk file
        test_file = self.root / "test.ahk"
        test_file.write_text("#Requires AutoHotkey v2.0\nMsgBox('Test')", encoding="utf-8")

        records = list(iterate_snippets(self.root))

        self.assertEqual(len(records), 1)
        self.assertIn("MsgBox", records[0].response)

    def test_skips_non_ahk_files(self):
        """Test that non-.ahk files are skipped."""
        (self.root / "test.txt").write_text("Not AHK", encoding="utf-8")
        (self.root / "test.py").write_text("# Python", encoding="utf-8")
        (self.root / "test.ahk").write_text("MsgBox('AHK')", encoding="utf-8")

        records = list(iterate_snippets(self.root))

        self.assertEqual(len(records), 1)

    def test_handles_nested_directories(self):
        """Test that nested directories are traversed."""
        subdir = self.root / "category" / "subcategory"
        subdir.mkdir(parents=True)

        (self.root / "root.ahk").write_text("MsgBox('Root')", encoding="utf-8")
        (subdir / "nested.ahk").write_text("MsgBox('Nested')", encoding="utf-8")

        records = list(iterate_snippets(self.root))

        self.assertEqual(len(records), 2)

    def test_strips_bom(self):
        """Test that BOM is stripped from files."""
        test_file = self.root / "bom.ahk"
        test_file.write_text("\ufeff#Requires AutoHotkey v2.0\nMsgBox('Test')", encoding="utf-8")

        records = list(iterate_snippets(self.root))

        self.assertEqual(len(records), 1)
        self.assertFalse(records[0].response.startswith("\ufeff"))

    def test_skips_empty_files(self):
        """Test that empty files are skipped."""
        (self.root / "empty.ahk").write_text("", encoding="utf-8")
        (self.root / "whitespace.ahk").write_text("   \n\n  ", encoding="utf-8")
        (self.root / "content.ahk").write_text("MsgBox('Test')", encoding="utf-8")

        records = list(iterate_snippets(self.root))

        self.assertEqual(len(records), 1)

    def test_metadata_fields(self):
        """Test that metadata contains required fields."""
        test_file = self.root / "test.ahk"
        test_file.write_text("MsgBox('Test')", encoding="utf-8")

        records = list(iterate_snippets(self.root))

        metadata = records[0].metadata
        self.assertIn("source_path", metadata)
        self.assertIn("category", metadata)
        self.assertIn("filename", metadata)
        self.assertIn("line_count", metadata)
        self.assertIn("record_type", metadata)
        self.assertEqual(metadata["record_type"], "snippet")

    def test_response_ends_with_newline(self):
        """Test that response ends with exactly one newline."""
        test_file = self.root / "test.ahk"
        test_file.write_text("MsgBox('Test')", encoding="utf-8")

        records = list(iterate_snippets(self.root))

        self.assertTrue(records[0].response.endswith("\n"))
        self.assertFalse(records[0].response.endswith("\n\n"))

    def test_handles_unicode_decode_errors(self):
        """Test that unicode decode errors are handled gracefully."""
        test_file = self.root / "test.ahk"
        # Write some bytes that might cause decode issues
        test_file.write_bytes(b"MsgBox('Test')\xff\xfe")

        records = list(iterate_snippets(self.root))

        # Should still process the file, possibly with replacement characters
        self.assertEqual(len(records), 1)


class TestIterateReferenceElements(unittest.TestCase):
    """Tests for iterate_reference_elements function."""

    def setUp(self):
        """Create temporary CSV file."""
        self.tmpdir = tempfile.TemporaryDirectory()
        self.csv_path = Path(self.tmpdir.name) / "test.csv"

    def tearDown(self):
        """Clean up temporary directory."""
        self.tmpdir.cleanup()

    def test_reads_csv_file(self):
        """Test that CSV file is read correctly."""
        self.csv_path.write_text(
            "Name,Description,ElementType,SourceFile,Path,Type,ReturnType,Symbol,Parameters\n"
            "TestFunc,Test function,Function,test.ahk,/test,Function,String,,param1\n",
            encoding="utf-8"
        )

        records = list(iterate_reference_elements(self.csv_path))

        self.assertEqual(len(records), 1)
        self.assertIn("TestFunc", records[0].prompt)
        self.assertIn("Test function", records[0].response)

    def test_skips_empty_name_or_description(self):
        """Test that rows with empty name or description are skipped."""
        self.csv_path.write_text(
            "Name,Description,ElementType\n"
            ",Description without name,Function\n"
            "NameWithoutDescription,,Function\n"
            "ValidEntry,Valid description,Function\n",
            encoding="utf-8"
        )

        records = list(iterate_reference_elements(self.csv_path))

        self.assertEqual(len(records), 1)
        self.assertIn("ValidEntry", records[0].prompt)

    def test_metadata_contains_record_type(self):
        """Test that metadata contains record_type='reference'."""
        self.csv_path.write_text(
            "Name,Description,ElementType\n"
            "TestFunc,Test function,Function\n",
            encoding="utf-8"
        )

        records = list(iterate_reference_elements(self.csv_path))

        self.assertEqual(records[0].metadata["record_type"], "reference")

    def test_handles_utf8_bom(self):
        """Test that UTF-8 BOM is handled correctly."""
        # Write file with BOM (utf-8-sig encoding adds BOM automatically)
        self.csv_path.write_text(
            "Name,Description,ElementType\n"
            "TestFunc,Test function,Function\n",
            encoding="utf-8-sig"
        )

        records = list(iterate_reference_elements(self.csv_path))

        self.assertEqual(len(records), 1)
        self.assertIn("TestFunc", records[0].prompt)

    def test_file_not_found(self):
        """Test that FileNotFoundError is raised for missing file."""
        with self.assertRaises(FileNotFoundError):
            list(iterate_reference_elements(Path("/nonexistent/file.csv")))


class TestDedupe(unittest.TestCase):
    """Tests for dedupe function."""

    def test_removes_duplicates(self):
        """Test that duplicate responses are removed."""
        records = [
            SnippetRecord("prompt1", "response1", {}),
            SnippetRecord("prompt2", "response1", {}),  # Duplicate response
            SnippetRecord("prompt3", "response2", {}),
        ]

        result = dedupe(records)

        self.assertEqual(len(result), 2)

    def test_keeps_first_occurrence(self):
        """Test that first occurrence is kept."""
        records = [
            SnippetRecord("first", "duplicate", {}),
            SnippetRecord("second", "duplicate", {}),
        ]

        result = dedupe(records)

        self.assertEqual(result[0].prompt, "first")

    def test_adds_sha256_to_metadata(self):
        """Test that SHA256 hash is added to metadata."""
        records = [
            SnippetRecord("prompt", "response", {"existing": "data"}),
        ]

        result = dedupe(records)

        self.assertIn("sha256", result[0].metadata)
        self.assertIn("existing", result[0].metadata)

        # Verify hash is correct
        expected_hash = hashlib.sha256("response".encode("utf-8")).hexdigest()
        self.assertEqual(result[0].metadata["sha256"], expected_hash)

    def test_empty_input(self):
        """Test handling of empty input."""
        result = dedupe([])
        self.assertEqual(len(result), 0)


class TestSplitRecords(unittest.TestCase):
    """Tests for split_records function."""

    def test_basic_split(self):
        """Test basic train/val/test split."""
        records = [SnippetRecord(f"p{i}", f"r{i}", {}) for i in range(100)]

        train, val, test = split_records(records, val_ratio=0.1, test_ratio=0.1, seed=42)

        self.assertEqual(len(train), 80)
        self.assertEqual(len(val), 10)
        self.assertEqual(len(test), 10)

    def test_total_count_preserved(self):
        """Test that total record count is preserved."""
        records = [SnippetRecord(f"p{i}", f"r{i}", {}) for i in range(100)]

        train, val, test = split_records(records, val_ratio=0.15, test_ratio=0.15, seed=42)

        self.assertEqual(len(train) + len(val) + len(test), 100)

    def test_seed_reproducibility(self):
        """Test that same seed produces same split."""
        records = [SnippetRecord(f"p{i}", f"r{i}", {}) for i in range(100)]

        train1, val1, test1 = split_records(records, val_ratio=0.1, test_ratio=0.1, seed=42)
        train2, val2, test2 = split_records(records, val_ratio=0.1, test_ratio=0.1, seed=42)

        self.assertEqual([r.prompt for r in train1], [r.prompt for r in train2])
        self.assertEqual([r.prompt for r in val1], [r.prompt for r in val2])
        self.assertEqual([r.prompt for r in test1], [r.prompt for r in test2])

    def test_invalid_ratios(self):
        """Test that invalid ratios raise ValueError."""
        records = [SnippetRecord("p", "r", {})]

        with self.assertRaises(ValueError):
            split_records(records, val_ratio=1.5, test_ratio=0.1, seed=42)

        with self.assertRaises(ValueError):
            split_records(records, val_ratio=-0.1, test_ratio=0.1, seed=42)

        with self.assertRaises(ValueError):
            split_records(records, val_ratio=0.5, test_ratio=0.6, seed=42)

    def test_zero_ratios(self):
        """Test handling of zero val/test ratios."""
        records = [SnippetRecord(f"p{i}", f"r{i}", {}) for i in range(100)]

        train, val, test = split_records(records, val_ratio=0.0, test_ratio=0.0, seed=42)

        self.assertEqual(len(train), 100)
        self.assertEqual(len(val), 0)
        self.assertEqual(len(test), 0)


class TestSnippetRecord(unittest.TestCase):
    """Tests for SnippetRecord dataclass."""

    def test_creation(self):
        """Test basic record creation."""
        record = SnippetRecord("test prompt", "test response", {"key": "value"})

        self.assertEqual(record.prompt, "test prompt")
        self.assertEqual(record.response, "test response")
        self.assertEqual(record.metadata["key"], "value")

    def test_metadata_optional(self):
        """Test that metadata can be empty."""
        record = SnippetRecord("prompt", "response", {})

        self.assertEqual(len(record.metadata), 0)


if __name__ == "__main__":
    unittest.main()
