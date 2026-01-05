# Test Suite

Comprehensive unit tests for the AHKv2_Finetune project.

## Test Files

### test_build_dataset.py
Tests for `src/build_dataset.py` - the dataset builder that converts raw AutoHotkey snippets into JSONL training pairs.

**Test Coverage:**
- `TestHumaniseTitle` (5 tests) - Tests for filename humanization
- `TestBuildPrompt` (2 tests) - Tests for prompt generation
- `TestIterateSnippets` (9 tests) - Tests for .ahk file processing
- `TestIterateReferenceElements` (5 tests) - Tests for CSV reference data processing
- `TestDedupe` (4 tests) - Tests for deduplication logic
- `TestSplitRecords` (5 tests) - Tests for train/val/test splitting
- `TestSnippetRecord` (2 tests) - Tests for dataclass functionality

**Total: 31 tests**

### test_data_prep.py
Tests for `src/data_prep.py` - the conversion utility that transforms simple JSONL into Harmony chat format.

**Test Coverage:**
- `TestToHarmony` (5 tests) - Tests for prompt/response to Harmony conversion
- `TestDataPrepIntegration` (2 tests) - End-to-end integration tests

**Total: 7 tests**

## Running Tests

### Run all tests:
```bash
python -m unittest discover tests -v
```

### Run specific test file:
```bash
python -m unittest tests.test_build_dataset -v
python -m unittest tests.test_data_prep -v
```

### Run specific test class:
```bash
python -m unittest tests.test_build_dataset.TestDedupe -v
```

### Run specific test method:
```bash
python -m unittest tests.test_build_dataset.TestDedupe.test_removes_duplicates -v
```

## Test Statistics

- **Total tests**: 38
- **Total test classes**: 9
- **Coverage**: Core functionality for dataset building and data preparation

## What's Tested

### Dataset Building (build_dataset.py)
✅ File discovery and reading
✅ .ahk file parsing with BOM handling
✅ Unicode decode error handling
✅ Empty file filtering
✅ Metadata extraction
✅ CSV reference data integration
✅ Deduplication with SHA256 hashing
✅ Train/val/test splitting with reproducibility
✅ Prompt generation
✅ Title humanization

### Data Preparation (data_prep.py)
✅ Prompt/response to Harmony format conversion
✅ Whitespace stripping
✅ Internal whitespace preservation
✅ Empty line handling
✅ End-to-end JSONL processing
✅ System message formatting

## Test Data

Tests use temporary directories and files created during test execution. No permanent test fixtures are stored in the repository.

## Adding New Tests

When adding new functionality:

1. Add corresponding tests in the appropriate test file
2. Follow existing naming conventions: `test_<functionality>`
3. Include clear docstrings describing what is being tested
4. Use descriptive assertion messages
5. Clean up any temporary resources in `tearDown()`

## Continuous Integration

These tests can be integrated into CI/CD pipelines:

```yaml
# Example GitHub Actions workflow
- name: Run tests
  run: python -m unittest discover tests -v
```

## Test Coverage Goals

Current coverage focuses on:
- ✅ Core dataset building logic
- ✅ Data format conversion
- ✅ Error handling
- ✅ Edge cases (empty files, unicode errors, etc.)

Future additions could include:
- Integration tests with actual training pipeline
- Performance/benchmark tests
- Validation script tests for #Include checker
