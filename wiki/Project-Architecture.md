# Project Architecture

Understanding how the AHKv2_Finetune pipeline works.

## Table of Contents

1. [Overview](#overview)
2. [Data Flow](#data-flow)
3. [Core Modules](#core-modules)
4. [Configuration](#configuration)
5. [Testing Infrastructure](#testing-infrastructure)
6. [Directory Structure](#directory-structure)

## Overview

The AHKv2_Finetune project is organized as a multi-stage pipeline that converts raw AutoHotkey v2 examples into a fine-tuned language model.

### High-Level Architecture

```
┌─────────────────┐
│  Raw .ahk Files │ (1,719 examples)
│  + CSV Data     │ (444 references)
└────────┬────────┘
         │
         ▼
┌────────────────────┐
│  build_dataset.py  │ → Converts to JSONL
│  - File discovery  │
│  - Deduplication   │
│  - Train/val/test  │
└────────┬───────────┘
         │
         ▼
┌────────────────────┐
│  Prompt/Response   │ (2,123 unique pairs)
│  JSONL Format      │
└────────┬───────────┘
         │
         ▼
┌────────────────────┐
│   data_prep.py     │ → Harmony chat format
│  - Message wrapping│
│  - System prompts  │
└────────┬───────────┘
         │
         ▼
┌────────────────────┐
│  Harmony Format    │ (Ready for training)
│  JSONL             │
└────────┬───────────┘
         │
         ▼
┌────────────────────┐
│  train_qlora.py    │ → QLoRA fine-tuning
│  - 4-bit quant     │
│  - LoRA adapters   │
│  - SFT training    │
└────────┬───────────┘
         │
         ▼
┌────────────────────┐
│  Fine-tuned Model  │
│  + LoRA adapters   │
└────────┬───────────┘
         │
         ▼
┌────────────────────┐
│  Merge Adapters    │ → Full model weights
└────────┬───────────┘
         │
         ▼
┌────────────────────┐
│  convert_to_gguf   │ → (Optional)
│  GGUF for LM Studio│
└────────────────────┘
```

## Data Flow

### Stage 1: Raw Data → JSONL

**Input:** `.ahk` files in `data/raw_scripts/`

**Process (`build_dataset.py`):**
1. Find all `.ahk` files recursively
2. Read each file (UTF-8, handle BOM)
3. Extract metadata (category, filename, path)
4. Build prompt template
5. Load CSV references (optional)
6. Deduplicate by SHA256 hash
7. Shuffle with seed
8. Split into train/val/test (80/10/10)
9. Write JSONL files

**Output:** `train.jsonl`, `val.jsonl`, `test.jsonl`

**Format:**
```json
{
  "prompt": "You are maintaining...",
  "response": "#Requires AutoHotkey v2.0\n...",
  "metadata": {"source_path": "...", "sha256": "..."}
}
```

### Stage 2: JSONL → Harmony Format

**Input:** `train.jsonl` (prompt/response pairs)

**Process (`data_prep.py`):**
1. Read each JSONL line
2. Wrap in Harmony message format:
   - System message (instructions)
   - User message (prompt)
   - Assistant message (response)
3. Write to new JSONL file

**Output:** `train_harmony.jsonl`

**Format:**
```json
{
  "messages": [
    {"role": "system", "content": "Reasoning medium..."},
    {"role": "user", "content": "You are maintaining..."},
    {"role": "assistant", "content": "#Requires..."}
  ]
}
```

### Stage 3: Training

**Input:** `train_harmony.jsonl`, `config/sft.yaml`

**Process (`train_qlora.py`):**
1. Load base model in 4-bit quantization
2. Add LoRA adapters to attention/MLP layers
3. Load training dataset
4. Train with SFTTrainer
5. Save LoRA adapters
6. (Optional) Merge adapters to full weights

**Output:** Fine-tuned model in `gpt-oss-finetuned/`

## Core Modules

### `src/build_dataset.py`

**Purpose:** Convert raw .ahk files to JSONL training pairs

**Key Functions:**

| Function | Purpose |
|----------|---------|
| `iterate_snippets()` | Find and read all .ahk files |
| `iterate_reference_elements()` | Load CSV reference data |
| `dedupe()` | Remove duplicates by SHA256 |
| `split_records()` | Train/val/test splitting |
| `write_jsonl()` | Write JSONL output files |
| `build_prompt()` | Generate prompt template |
| `humanise_title()` | Clean up filenames |

**Key Classes:**

```python
@dataclass
class SnippetRecord:
    prompt: str        # Generated prompt
    response: str      # AutoHotkey code
    metadata: dict     # Source info, hash, etc.
```

**Testing:** 31 unit tests in `tests/test_build_dataset.py`

### `src/data_prep.py`

**Purpose:** Convert prompt/response JSONL to Harmony chat format

**Key Functions:**

| Function | Purpose |
|----------|---------|
| `to_harmony()` | Convert to message format |
| `main()` | CLI entry point |

**Conversion Logic:**
```python
def to_harmony(prompt, response):
    return {
        "messages": [
            {"role": "system", "content": "Reasoning medium. You are a helpful assistant."},
            {"role": "user", "content": prompt.strip()},
            {"role": "assistant", "content": response.strip()},
        ]
    }
```

**Testing:** 7 unit tests in `tests/test_data_prep.py`

### `src/train_qlora.py`

**Purpose:** Fine-tune model with QLoRA

**Key Features:**
- **4-bit quantization** via `load_in_4bit=True`
- **LoRA adapters** on all attention and MLP layers
- **SFTTrainer** from TRL library
- **Merge mode** to combine adapters with base model
- **YAML configuration** for hyperparameters

**Configuration Loading:**
```python
def load_config(config_path):
    with open(config_path) as f:
        return yaml.safe_load(f)
```

**Training Loop:**
1. Load config from YAML
2. Load base model (4-bit)
3. Add LoRA adapters
4. Load dataset
5. Train with SFTTrainer
6. Save adapters
7. (Optional) Merge and save full model

### `scripts/normalize_snippets.py`

**Purpose:** Clean up conversion artifacts in .ahk files

**Features:**
- Regex-based find/replace
- Dry-run mode
- JSON report generation
- Custom pattern support

**Usage:**
```bash
python scripts/normalize_snippets.py \
    --root data/raw_scripts \
    --pattern "V1toV2_GblCode_001=GlobalInitBlock" \
    --dry-run
```

### `scripts/validate_includes.py`

**Purpose:** Validate #Include references in .ahk files

**Features:**
- Find all `#Include` directives
- Support for library (`<name>`) and file (`"path"`) includes
- Path resolution (relative, absolute, Lib/ subdirectory)
- Detailed validation reports
- Auto-fix broken includes (--fix flag)

**Path Resolution Logic:**
1. Library includes: Check `Lib/<name>.ahk` relative to script/root
2. File includes: Check relative to source file, then root
3. Absolute paths: Use as-is

## Configuration

### `config/sft.yaml`

Central configuration for training:

```yaml
# Model settings
base_model: "openai/gpt-oss-20b"
max_seq_length: 1024
load_in_4bit: true

# LoRA configuration
lora:
  r: 8                    # LoRA rank
  alpha: 16               # LoRA alpha (scaling)
  dropout: 0.0            # Dropout (0 = no dropout)
  target_modules:         # Which layers to add adapters
    - q_proj
    - k_proj
    - v_proj
    - o_proj
    - gate_proj
    - up_proj
    - down_proj

# Training hyperparameters
training:
  dataset_path: "data/prepared/train.jsonl"
  num_train_epochs: 1
  per_device_train_batch_size: 1
  gradient_accumulation_steps: 4
  learning_rate: 2.0e-4
  optimizer: "adamw_8bit"
  lr_scheduler_type: "linear"
  warmup_ratio: 0.05
  weight_decay: 0.01
  max_grad_norm: 1.0
  logging_steps: 10
  save_steps: 100
  save_total_limit: 3
  fp16: true              # Mixed precision training

# Output settings
output:
  output_dir: "gpt-oss-finetuned"
  merged_dir: "gpt-oss-finetuned-merged"
```

## Testing Infrastructure

### Unit Tests

**Location:** `tests/` directory

**Test Files:**
- `tests/test_build_dataset.py` (31 tests)
- `tests/test_data_prep.py` (7 tests)

**Test Coverage:**
- File discovery and parsing
- Deduplication logic
- Train/val/test splitting
- Prompt generation
- Format conversion
- Error handling (unicode, empty files, etc.)

**Running Tests:**
```bash
# All tests
python -m unittest discover tests -v

# Specific file
python -m unittest tests.test_build_dataset -v

# Specific test
python -m unittest tests.test_build_dataset.TestDedupe.test_removes_duplicates -v
```

### Validation Scripts

**`scripts/validate_includes.py`:**
- Scans all .ahk files for #Include directives
- Validates referenced files exist
- Generates detailed reports
- Can auto-fix broken references

**Usage:**
```bash
python scripts/validate_includes.py --root data/raw_scripts --report tmp/report.txt
```

## Directory Structure

```
AHKv2_Finetune/
├── config/
│   └── sft.yaml              # Training configuration
├── data/
│   ├── raw_scripts/          # Input .ahk files
│   │   └── AHK_v2_Examples/  # 1,719 example files
│   ├── elements.csv          # CSV reference data (444 entries)
│   ├── samples.jsonl         # Sample data for testing
│   └── prepared/             # Generated datasets (gitignored)
│       ├── train.jsonl
│       ├── val.jsonl
│       ├── test.jsonl
│       ├── train_harmony.jsonl
│       ├── val_harmony.jsonl
│       └── test_harmony.jsonl
├── docs/                     # Documentation
│   ├── AHK_v2_Examples_Classification_Guide.md
│   ├── AHK_v2_Examples_Feature_Guide.md
│   └── dataset_guidelines.md
├── research/                 # Research & analysis
│   ├── PRUNING_RECOMMENDATIONS.md
│   ├── EXAMPLES_SUMMARY.md
│   └── ...
├── scripts/                  # Utility scripts
│   ├── convert_to_gguf.sh
│   ├── normalize_snippets.py
│   ├── validate_includes.py
│   └── setup.sh
├── src/                      # Core pipeline
│   ├── build_dataset.py      # Dataset builder
│   ├── data_prep.py          # Format converter
│   └── train_qlora.py        # Training script
├── tests/                    # Unit tests
│   ├── __init__.py
│   ├── test_build_dataset.py
│   └── test_data_prep.py
├── tmp/                      # Temporary files
│   ├── normalization_report.json
│   └── include_validation_report.txt
├── wiki/                     # Project documentation
│   ├── Home.md
│   ├── Getting-Started.md
│   ├── Dataset-Building.md
│   ├── Troubleshooting.md
│   ├── FAQ.md
│   └── Project-Architecture.md (this file)
├── .gitignore                # Git ignore rules
├── README.md                 # Project overview
├── requirements.txt          # Python dependencies
└── prune_examples.sh         # Example cleanup script
```

### Gitignored Directories

The following are not committed to version control:

```
.venv/                        # Virtual environment
data/prepared/                # Generated datasets
gpt-oss-finetuned/            # Trained model
gpt-oss-finetuned-merged/     # Merged model
*.gguf                        # GGUF files
__pycache__/                  # Python cache
*.pyc                         # Compiled Python
```

## Key Design Decisions

### 1. Separation of Concerns

Each script has a single responsibility:
- `build_dataset.py` - Data ingestion and formatting
- `data_prep.py` - Format conversion
- `train_qlora.py` - Model training

This makes the pipeline:
- **Easier to test** (isolated components)
- **Easier to modify** (change one stage without affecting others)
- **Easier to debug** (failures isolated to specific stages)

### 2. YAML Configuration

Training configuration is in YAML instead of Python because:
- **Non-programmers** can adjust hyperparameters
- **Version control friendly** (easy to diff configs)
- **No code changes** needed for experiments
- **Shareable** (share configs with others)

### 3. Metadata Tracking

Every training example includes metadata:
- **Source attribution** (trace back to original file)
- **Deduplication** (SHA256 hash)
- **Category tracking** (filter/analyze by category)
- **Debugging** (inspect problematic examples)

### 4. Reproducibility

Explicit seed values ensure:
- **Same splits** across runs (train/val/test)
- **Comparable results** (same random initialization)
- **Debugging** (reproduce exact conditions)

### 5. Validation First

Multiple validation layers:
- **Unit tests** (38 tests, automated)
- **#Include validation** (catch broken references)
- **Dry-run mode** (preview without writing files)
- **Test dataset** (held-out evaluation)

## Extension Points

### Adding New Data Sources

To add examples from a new source:

1. Add `.ahk` files to `data/raw_scripts/`
2. Optionally create subdirectory for organization
3. Rebuild dataset: `python -m src.build_dataset ...`

### Adding New Formats

To support a different chat format (e.g., Alpaca):

1. Create new conversion function:
   ```python
   def to_alpaca(prompt, response):
       return {
           "instruction": prompt,
           "input": "",
           "output": response
       }
   ```

2. Modify `data_prep.py` to use new format

### Adding Evaluation Metrics

Create `scripts/evaluate.py`:

```python
def evaluate(model, test_data):
    # Load test set
    # Generate predictions
    # Compute metrics (BLEU, exact match, etc.)
    # Return results
```

### Adding Custom Preprocessing

Extend `build_dataset.py`:

```python
def preprocess_snippet(code: str) -> str:
    # Custom cleaning logic
    # Remove comments
    # Normalize whitespace
    # Fix common issues
    return cleaned_code
```

## Performance Considerations

### Memory Usage

- **4-bit quantization** reduces model memory by ~75%
- **LoRA** trains only 0.05% of parameters
- **Gradient checkpointing** trades compute for memory
- **Batch size 1** minimizes memory (can train on 12GB GPU)

### Training Speed

- **Gradient accumulation** simulates larger batches
- **Mixed precision (fp16)** speeds up computation
- **Unsloth optimizations** provide 2x speedup
- **Flash Attention** (if available) further accelerates

### Dataset Building

- **Single-pass** file reading
- **SHA256** computed once per file
- **Memory-efficient** streaming JSONL writes
- **Fast** on SSD (<1 minute for 1,719 files)

## Next Steps

- **[Getting Started](Getting-Started.md)** - Setup and run the pipeline
- **[Dataset Building](Dataset-Building.md)** - Customize your dataset
- **[FAQ](FAQ.md)** - Common questions
- **[Troubleshooting](Troubleshooting.md)** - Fix issues

---

**Last Updated:** 2025-11-19
