# AutoHotkey v2 Fine-Tuning Project

Welcome to the **AHKv2_Finetune** project! This repository provides a complete pipeline for fine-tuning the `openai/gpt-oss-20b` model on AutoHotkey v2 code examples using Unsloth QLoRA.

## 🎯 Project Overview

This project enables you to:
- **Build high-quality datasets** from 1,746 AutoHotkey v2 examples
- **Fine-tune large language models** to generate AutoHotkey v2 code
- **Convert models to GGUF** for local inference in LM Studio or llama.cpp
- **Validate code quality** with automated testing and #Include validation

## 📊 Dataset Statistics

- **1,746 .ahk files** (45,000+ lines of code)
- **1,730 unique examples** (estimated after deduplication)
- **2,150+ training pairs** with CSV reference data
- **99.9% v2 verified** (1,745/1,746 files)
- **Comprehensive coverage** of all AHK v2 features including library usage
- **Complete metadata catalog** available (`data/examples_catalog.json`)

### Example Categories

| Category | Files | Description |
|----------|-------|-------------|
| Array Operations | 82 | Library usage, standalone, advanced patterns |
| Standard Library | 95 | Built-in function examples |
| Advanced Examples | 50 | OOP, data structures, design patterns |
| Control Flow | 43 | If/loops/try-catch/ByRef |
| File Operations | 60+ | File I/O, directory management |
| GUI Examples | 51+ | Window creation, controls, events |
| String Operations | 68+ | String manipulation, parsing |
| Window Management | 49 | Window detection, positioning |
| Hotkeys & Input | 34 | Hotkey definitions, input simulation |
| Library Examples | 27 | Real-world library usage (UIA, OCR, ImagePut, JSON, HTTP, CLR) |

## 🚀 Quick Start

### Prerequisites
- Python 3.8+
- CUDA-capable GPU (12-16GB VRAM recommended)
- 20GB+ free disk space

### Installation

```bash
# Clone the repository
git clone https://github.com/012090120901209/AHKv2_Finetune.git
cd AHKv2_Finetune

# Create virtual environment
python -m venv .venv
source .venv/bin/activate  # Linux/Mac
# OR
.\.venv\Scripts\Activate.ps1  # Windows

# Install dependencies
pip install -U pip
pip install -r requirements.txt
```

### Basic Workflow

```bash
# 1. Build dataset from raw .ahk files
python -m src.build_dataset \
    --input-dir data/raw_scripts \
    --output-dir data/prepared \
    --elements-csv data/elements.csv

# 2. Convert to Harmony chat format
python -m src.data_prep \
    --in data/prepared/train.jsonl \
    --out data/prepared/train_harmony.jsonl

# 3. Train the model
python src/train_qlora.py --config config/sft.yaml

# 4. Merge adapters to full weights
python src/train_qlora.py --config config/sft.yaml --merge_only 1

# 5. Convert to GGUF for local inference
bash scripts/convert_to_gguf.sh gpt-oss-finetuned-merged gpt-oss-finetuned.gguf
```

## 📁 Repository Structure

```
AHKv2_Finetune/
├── src/                      # Core fine-tuning pipeline
│   ├── build_dataset.py      # Dataset builder (converts .ahk → JSONL)
│   ├── data_prep.py          # Harmony format converter
│   └── train_qlora.py        # QLoRA training script
├── config/                   # Training configuration
│   └── sft.yaml              # Hyperparameters, model settings
├── scripts/                  # Utility scripts
│   ├── normalize_snippets.py # Clean conversion artifacts
│   ├── validate_includes.py  # Check #Include references
│   └── convert_to_gguf.sh    # GGUF export script
├── data/                     # Training data
│   ├── raw_scripts/          # 1,719 .ahk example files
│   ├── elements.csv          # 444 reference entries
│   └── prepared/             # Generated datasets (gitignored)
├── docs/                     # Documentation
│   ├── AHK_v2_Examples_Classification_Guide.md
│   ├── AHK_v2_Examples_Feature_Guide.md
│   └── dataset_guidelines.md
├── tests/                    # Unit tests (38 tests, 100% pass)
│   ├── test_build_dataset.py
│   └── test_data_prep.py
├── research/                 # Research and analysis files
│   ├── PRUNING_RECOMMENDATIONS.md
│   ├── EXAMPLES_SUMMARY.md
│   └── GITHUB_SCRAPING_GUIDE.md
└── wiki/                     # Project wiki documentation
```

## 🔥 Key Features

### 1. High-Quality Dataset
- **Curated examples** from multiple sources
- **Automatic deduplication** using SHA256 hashing
- **Metadata tracking** for source attribution
- **CSV integration** for official documentation

### 2. Robust Pipeline
- **Validated with 38 unit tests** (100% pass rate)
- **Error handling** for unicode, empty files, malformed data
- **#Include validation** to detect broken references
- **Reproducible splits** with configurable seed

### 3. Flexible Training
- **QLoRA optimization** for low-VRAM GPUs
- **YAML configuration** for easy hyperparameter tuning
- **Merge-only mode** for adapter conversion
- **GGUF export** for local inference

### 4. Comprehensive Documentation
- **Feature guides** documenting all 1,719 examples
- **Classification guides** explaining categorization
- **Research notes** on data collection methodology
- **API documentation** for all modules

## 📚 Wiki Navigation

- **[Home](Home.md)** - This page
- **[Getting Started](Getting-Started.md)** - Installation and first steps
- **[Dataset Building](Dataset-Building.md)** - How to build training datasets
- **[Training Guide](Training-Guide.md)** - Model fine-tuning process
- **[API Reference](API-Reference.md)** - Code documentation
- **[Troubleshooting](Troubleshooting.md)** - Common issues and solutions
- **[FAQ](FAQ.md)** - Frequently asked questions
- **[Project Architecture](Project-Architecture.md)** - How everything fits together

## 🧪 Testing

Run the comprehensive test suite:

```bash
# Run all tests
python -m unittest discover tests -v

# Run specific test file
python -m unittest tests.test_build_dataset -v

# Validate #Include references
python scripts/validate_includes.py --root data/raw_scripts
```

**Test Coverage:**
- ✅ 38 unit tests (100% pass)
- ✅ Dataset building and deduplication
- ✅ Data format conversion
- ✅ Error handling and edge cases
- ✅ #Include reference validation

## 🎓 Example Output

The fine-tuned model can generate AutoHotkey v2 code like:

**Prompt:**
```
Write an AutoHotkey script that shows a message box when pressing Ctrl+J
```

**Generated Code:**
```autohotkey
#Requires AutoHotkey v2.0
^j::MsgBox("You pressed Ctrl+J!")
```

## 🤝 Contributing

Contributions are welcome! Areas for improvement:

- **Add more examples** from real-world AHK v2 projects
- **Improve test coverage** for edge cases
- **Optimize training** hyperparameters
- **Add validation** for generated code
- **Create benchmarks** for model performance

## 📄 License

See LICENSE file for details.

## 🔗 Resources

- [AutoHotkey v2 Documentation](https://www.autohotkey.com/docs/v2/)
- [Unsloth GitHub](https://github.com/unslothai/unsloth)
- [QLoRA Paper](https://arxiv.org/abs/2305.14314)
- [Harmony Chat Format](https://docs.together.ai/docs/chat-models)

## 📞 Support

For questions or issues:
1. Check the [FAQ](FAQ.md)
2. Review [Troubleshooting](Troubleshooting.md)
3. Search existing GitHub issues
4. Open a new issue with details

---

**Last Updated:** 2025-11-19
**Version:** 1.0.0
**Dataset Size:** 1,719 examples, 1,703 unique
