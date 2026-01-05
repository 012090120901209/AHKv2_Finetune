# Dataset Building Guide

This guide explains how to build high-quality training datasets from AutoHotkey v2 example files.

## Table of Contents

1. [Overview](#overview)
2. [Dataset Pipeline](#dataset-pipeline)
3. [Build Dataset Script](#build-dataset-script)
4. [Data Preparation Script](#data-preparation-script)
5. [Dataset Quality](#dataset-quality)
6. [Customization](#customization)
7. [Advanced Topics](#advanced-topics)

## Overview

The dataset building process converts 1,719 raw `.ahk` files into structured JSONL training pairs suitable for fine-tuning language models.

### Input

- **1,719 .ahk files** in `data/raw_scripts/AHK_v2_Examples/`
- **444 CSV reference entries** in `data/elements.csv`

### Output

- **train.jsonl** - 1,699 training examples (80%)
- **val.jsonl** - 212 validation examples (10%)
- **test.jsonl** - 212 test examples (10%)
- **Harmony format** - Converted to chat format for training

### Pipeline Flow

```
Raw .ahk files → Build Dataset → JSONL (prompt/response) → Data Prep → Harmony format → Training
```

## Dataset Pipeline

### Stage 1: Raw Examples

Example `.ahk` file structure:

```autohotkey
#Requires AutoHotkey v2.0
#Include <adash>

; Category: Array Operations
; Example: Chunking an array into groups

arr := [1, 2, 3, 4, 5, 6]
result := _.chunk(arr, 2)
MsgBox(result[1][1])  ; Output: 1
```

### Stage 2: JSONL Format (build_dataset.py)

Converts to prompt/response pairs:

```json
{
  "prompt": "You are maintaining a knowledge base of AutoHotkey examples.\nCategory: Array Operations\nExample ID: Array_01_Chunk\nSource Path: AHK_v2_Examples/Array_01_Chunk.ahk\nReturn the exact AutoHotkey snippet associated with this reference.",
  "response": "#Requires AutoHotkey v2.0\n#Include <adash>\n\narr := [1, 2, 3, 4, 5, 6]\nresult := _.chunk(arr, 2)\nMsgBox(result[1][1])\n",
  "metadata": {
    "source_path": "AHK_v2_Examples/Array_01_Chunk.ahk",
    "category": "AHK_v2_Examples",
    "filename": "Array_01_Chunk.ahk",
    "line_count": 8,
    "record_type": "snippet",
    "sha256": "abc123..."
  }
}
```

### Stage 3: Harmony Format (data_prep.py)

Converts to chat conversation format:

```json
{
  "messages": [
    {
      "role": "system",
      "content": "Reasoning medium. You are a helpful assistant."
    },
    {
      "role": "user",
      "content": "You are maintaining a knowledge base of AutoHotkey examples..."
    },
    {
      "role": "assistant",
      "content": "#Requires AutoHotkey v2.0\n#Include <adash>\n..."
    }
  ]
}
```

## Build Dataset Script

### Basic Usage

```bash
python -m src.build_dataset \
    --input-dir data/raw_scripts \
    --output-dir data/prepared
```

### All Options

```bash
python -m src.build_dataset \
    --input-dir data/raw_scripts \
    --output-dir data/prepared \
    --train-file train.jsonl \
    --val-file val.jsonl \
    --test-file test.jsonl \
    --val-ratio 0.1 \
    --test-ratio 0.1 \
    --seed 2025 \
    --elements-csv data/elements.csv \
    --dry-run
```

### Options Explained

| Option | Default | Description |
|--------|---------|-------------|
| `--input-dir` | `data/raw_scripts` | Directory containing .ahk files |
| `--output-dir` | `data/prepared` | Where to write JSONL files |
| `--train-file` | `train.jsonl` | Training set filename |
| `--val-file` | `val.jsonl` | Validation set filename |
| `--test-file` | `test.jsonl` | Test set filename |
| `--val-ratio` | `0.1` | Validation set size (10%) |
| `--test-ratio` | `0.1` | Test set size (10%) |
| `--seed` | `2025` | Random seed for reproducibility |
| `--elements-csv` | None | CSV file with reference data |
| `--dry-run` | False | Show stats without writing files |

### What It Does

1. **Find all .ahk files** recursively in input directory
2. **Read each file** with UTF-8 encoding (handles BOM)
3. **Extract metadata** (category, filename, line count, source path)
4. **Build prompt** describing the example
5. **Load CSV references** (if provided) and merge
6. **Deduplicate** using SHA256 hash of response content
7. **Shuffle** examples with specified seed
8. **Split** into train/val/test sets
9. **Write JSONL files** to output directory

### Example Output

```
Loaded 1719 raw snippets from data/raw_scripts.
Loaded 444 reference entries from data/elements.csv.
Total records with reference data: 2163 (added 444).
After deduplication: 2123 unique records.
Split sizes (train/val/test): 1699/212/212
Wrote datasets to data/prepared.
```

## Data Preparation Script

### Basic Usage

```bash
python -m src.data_prep \
    --in data/prepared/train.jsonl \
    --out data/prepared/train_harmony.jsonl
```

### What It Does

Converts simple prompt/response JSONL to Harmony chat format:

**Input:**
```json
{"prompt": "...", "response": "...", "metadata": {...}}
```

**Output:**
```json
{
  "messages": [
    {"role": "system", "content": "Reasoning medium. You are a helpful assistant."},
    {"role": "user", "content": "..."},
    {"role": "assistant", "content": "..."}
  ]
}
```

### Processing All Splits

```bash
# Convert train set
python -m src.data_prep \
    --in data/prepared/train.jsonl \
    --out data/prepared/train_harmony.jsonl

# Convert validation set
python -m src.data_prep \
    --in data/prepared/val.jsonl \
    --out data/prepared/val_harmony.jsonl

# Convert test set
python -m src.data_prep \
    --in data/prepared/test.jsonl \
    --out data/prepared/test_harmony.jsonl
```

## Dataset Quality

### Deduplication

The build_dataset script automatically deduplicates examples:

- Uses **SHA256 hash** of response content
- Keeps **first occurrence** of duplicates
- Adds **hash to metadata** for tracking
- **1,719 files → 1,703 unique** (16 duplicates removed)

### Validation

Check dataset quality with included tools:

```bash
# Validate #Include references
python scripts/validate_includes.py --root data/raw_scripts

# Run unit tests
python -m unittest tests.test_build_dataset -v

# Inspect first example
head -1 data/prepared/train.jsonl | python -m json.tool
```

### Dataset Statistics

After building, you'll have:

- **1,699 training examples** (80%)
- **212 validation examples** (10%)
- **212 test examples** (10%)
- **2,123 total unique records** (with CSV data)

### Coverage Analysis

The dataset covers all AutoHotkey v2 features:

| Feature Category | Coverage | Examples |
|-----------------|----------|----------|
| Array Operations | ✅ Complete | 82 |
| Standard Library | ✅ Complete | 95 |
| OOP & Classes | ✅ Complete | 50 |
| GUI Programming | ✅ Complete | 51 |
| String Manipulation | ✅ Complete | 68 |
| File I/O | ✅ Complete | 60 |
| Control Flow | ✅ Complete | 43 |
| Window Management | ✅ Complete | 49 |
| Hotkeys & Input | ✅ Complete | 34 |

## Customization

### Adding Your Own Examples

1. Add `.ahk` files to `data/raw_scripts/` directory
2. Follow naming convention: `Category_Description.ahk`
3. Include `#Requires AutoHotkey v2.0` header
4. Rebuild dataset:

```bash
python -m src.build_dataset \
    --input-dir data/raw_scripts \
    --output-dir data/prepared
```

### Adjusting Split Ratios

For more validation data (useful for hyperparameter tuning):

```bash
python -m src.build_dataset \
    --val-ratio 0.15 \
    --test-ratio 0.15 \
    --seed 2025
```

This gives:
- **70% training** (1,486 examples)
- **15% validation** (318 examples)
- **15% test** (318 examples)

### Filtering by Category

To create a dataset with only specific categories:

```python
# Create custom filtering script
import json
from pathlib import Path

def filter_by_category(input_file, output_file, categories):
    with open(input_file) as f_in, open(output_file, 'w') as f_out:
        for line in f_in:
            record = json.loads(line)
            if record['metadata']['category'] in categories:
                f_out.write(json.dumps(record) + '\n')

# Filter for only GUI and Array examples
filter_by_category(
    'data/prepared/train.jsonl',
    'data/prepared/train_gui_array.jsonl',
    categories=['GUI', 'Array']
)
```

### Custom Prompts

Edit `src/build_dataset.py` to customize prompt format:

```python
def build_prompt(category: str, title: str, source_path: str) -> str:
    """Customize your prompt template here."""
    return f"""
Generate AutoHotkey v2 code for the following:
Category: {category}
Task: {humanise_title(title)}
Reference: {source_path}
"""
```

## Advanced Topics

### Normalizing Snippets

Clean up conversion artifacts before building dataset:

```bash
python scripts/normalize_snippets.py \
    --root data/raw_scripts \
    --pattern "V1toV2_GblCode_001=GlobalInitBlock" \
    --report tmp/normalization_report.json
```

### Adding CSV Reference Data

The `elements.csv` file contains 444 official reference entries:

```csv
Name,Description,ElementType,SourceFile,Path,Type,ReturnType,Symbol,Parameters
FileRead,Reads file contents,Function,file.ahk,/file,Function,String,,path
MsgBox,Displays a message,Function,gui.ahk,/gui,Function,String,,text
```

These are automatically merged during dataset building.

### Reproducible Splits

Use the same seed to get identical train/val/test splits:

```bash
# First run
python -m src.build_dataset --seed 42

# Later run with same seed = same splits
python -m src.build_dataset --seed 42
```

### Dry Run Mode

Preview dataset statistics without writing files:

```bash
python -m src.build_dataset --dry-run
```

Output:
```
Loaded 1719 raw snippets from data/raw_scripts.
After deduplication: 1703 unique records.
Split sizes (train/val/test): 1363/170/170
Dry run complete; no files written.
```

### Metadata Enrichment

Each training example includes rich metadata:

```json
{
  "metadata": {
    "source_path": "AHK_v2_Examples/Array_01_Chunk.ahk",
    "category": "AHK_v2_Examples",
    "filename": "Array_01_Chunk.ahk",
    "line_count": 8,
    "record_type": "snippet",
    "sha256": "abc123def456..."
  }
}
```

Use this for:
- **Source attribution** - trace examples back to original files
- **Category filtering** - create specialized datasets
- **Deduplication** - identify and remove duplicates
- **Quality analysis** - find examples by characteristics

### Large-Scale Dataset Building

For datasets with >10,000 examples:

```bash
# Use progress bar (if tqdm installed)
python -m src.build_dataset --progress

# Process in batches
python -m src.build_dataset --batch-size 1000
```

## Next Steps

- **[Training Guide](Training-Guide.md)** - Learn how to train models
- **[API Reference](API-Reference.md)** - Understand the build_dataset.py code
- **[Troubleshooting](Troubleshooting.md)** - Fix dataset issues

---

**Related Documentation:**
- [Getting Started](Getting-Started.md) - Setup and first steps
- [Project Architecture](Project-Architecture.md) - How the pipeline works
- [FAQ](FAQ.md) - Common questions
