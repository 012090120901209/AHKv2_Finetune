# Getting Started

This guide will walk you through setting up the AHKv2_Finetune project and running your first fine-tuning experiment.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Quick Smoke Test](#quick-smoke-test)
4. [Understanding the Dataset](#understanding-the-dataset)
5. [Building Your First Dataset](#building-your-first-dataset)
6. [Training Your First Model](#training-your-first-model)
7. [Testing Your Model](#testing-your-model)
8. [Next Steps](#next-steps)

## Prerequisites

### System Requirements

**Minimum:**
- Python 3.8 or higher
- 16GB RAM
- 20GB free disk space
- CUDA-capable GPU with 12GB VRAM (for training)

**Recommended:**
- Python 3.10+
- 32GB RAM
- 50GB free disk space
- CUDA-capable GPU with 16GB+ VRAM (RTX 3090, RTX 4090, A6000, etc.)

### Software Dependencies

- **Python 3.8+** - Language runtime
- **CUDA 11.8+** - GPU acceleration (for NVIDIA GPUs)
- **Git** - Version control
- **pip** - Python package manager

### Check Your Environment

```bash
# Check Python version (should be 3.8+)
python --version

# Check CUDA availability (if using GPU)
python -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}')"

# Check GPU memory (if using NVIDIA GPU)
nvidia-smi
```

## Installation

### Step 1: Clone the Repository

```bash
git clone https://github.com/012090120901209/AHKv2_Finetune.git
cd AHKv2_Finetune
```

### Step 2: Create Virtual Environment

**Linux/Mac:**
```bash
python -m venv .venv
source .venv/bin/activate
```

**Windows PowerShell:**
```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```

**Windows Command Prompt:**
```cmd
python -m venv .venv
.venv\Scripts\activate.bat
```

### Step 3: Upgrade pip

```bash
pip install --upgrade pip
```

### Step 4: Install Dependencies

```bash
pip install -r requirements.txt
```

**Expected installation time:** 5-10 minutes (depending on internet speed)

### Step 5: Verify Installation

```bash
# Run unit tests to verify installation
python -m unittest discover tests -v
```

**Expected output:**
```
Ran 38 tests in 0.030s
OK
```

## Quick Smoke Test

Let's verify everything works with a minimal training run.

### 1. Prepare Sample Data

The repository includes a sample dataset in `data/samples.jsonl`. Convert it to Harmony format:

```bash
python src/data_prep.py \
    --in data/samples.jsonl \
    --out data/prepared/train.jsonl
```

**Expected output:**
```
✓ Created data/prepared/train.jsonl with 2 examples
```

### 2. Run Minimal Training

Run a tiny training experiment (30 steps, ~2 minutes):

```bash
python src/train_qlora.py --config config/sft.yaml --max_steps 30
```

**Expected output:**
```
Loading model: openai/gpt-oss-20b
✓ Model loaded with 4-bit quantization
Training for 30 steps...
Step 30/30 | Loss: X.XXX | LR: X.XXe-X
✓ Training complete
Model saved to: gpt-oss-finetuned/
```

**Training time:** ~2-5 minutes on RTX 3090

### 3. Test Model Loading

Verify the model can be loaded:

```bash
python -c "from transformers import AutoModelForCausalLM; print('Model loads successfully')"
```

## Understanding the Dataset

### Dataset Structure

The project contains **1,719 AutoHotkey v2 examples** organized by category:

```
data/raw_scripts/AHK_v2_Examples/
├── Array_01_Chunk.ahk
├── Array_02_Compact.ahk
├── StdLib_01_FileRead.ahk
├── StdLib_02_FileWrite.ahk
├── Advanced_Class_Singleton.ahk
├── GUI_Button_Click.ahk
└── ... (1,715 more files)
```

### Example File Format

Each `.ahk` file contains:

```autohotkey
#Requires AutoHotkey v2.0

; Category: Array Operations
; Description: Demonstrates chunk() function

arr := [1, 2, 3, 4, 5, 6]
chunked := chunk(arr, 2)
MsgBox(chunked[1][1])  ; Shows: 1
```

### Dataset Categories

| Category | Count | Examples |
|----------|-------|----------|
| Array Operations | 82 | chunk, compact, flatten, zip |
| Standard Library | 95 | FileRead, InStr, Format, Ternary |
| Advanced | 50 | OOP, data structures, design patterns |
| GUI | 51 | MsgBox, InputBox, custom GUIs |
| String | 68 | SubStr, InStr, RegEx, parsing |
| File I/O | 60 | FileRead, FileAppend, DirCopy |
| Control Flow | 43 | If, Loop, Try-Catch, ByRef |

See [Dataset Building](Dataset-Building.md) for more details.

## Building Your First Dataset

### Step 1: Validate Raw Data

Check that all example files are present:

```bash
# Count .ahk files
find data/raw_scripts -name "*.ahk" | wc -l
```

**Expected:** `1719`

### Step 2: Validate #Include References

```bash
python scripts/validate_includes.py --root data/raw_scripts
```

**Expected:** 50 #Include directives found (all external libraries - this is normal)

### Step 3: Build Dataset

Convert .ahk files to JSONL training pairs:

```bash
python -m src.build_dataset \
    --input-dir data/raw_scripts \
    --output-dir data/prepared \
    --elements-csv data/elements.csv
```

**Expected output:**
```
Loaded 1719 raw snippets from data/raw_scripts.
Loaded 444 reference entries from data/elements.csv.
Total records with reference data: 2163 (added 444).
After deduplication: 2123 unique records.
Split sizes (train/val/test): 1699/212/212
Wrote datasets to data/prepared.
```

**Output files:**
- `data/prepared/train.jsonl` - 1,699 training examples
- `data/prepared/val.jsonl` - 212 validation examples
- `data/prepared/test.jsonl` - 212 test examples

### Step 4: Convert to Harmony Format

```bash
# Convert train split
python -m src.data_prep \
    --in data/prepared/train.jsonl \
    --out data/prepared/train_harmony.jsonl

# Convert validation split
python -m src.data_prep \
    --in data/prepared/val.jsonl \
    --out data/prepared/val_harmony.jsonl

# Convert test split
python -m src.data_prep \
    --in data/prepared/test.jsonl \
    --out data/prepared/test_harmony.jsonl
```

### Step 5: Inspect Dataset

Look at a sample training example:

```bash
head -1 data/prepared/train_harmony.jsonl | python -m json.tool
```

**Example output:**
```json
{
  "messages": [
    {
      "role": "system",
      "content": "Reasoning medium. You are a helpful assistant."
    },
    {
      "role": "user",
      "content": "You are maintaining a knowledge base of AutoHotkey examples.\nCategory: Array\nExample ID: Array_01_Chunk\nSource Path: AHK_v2_Examples/Array_01_Chunk.ahk\nReturn the exact AutoHotkey snippet associated with this reference."
    },
    {
      "role": "assistant",
      "content": "#Requires AutoHotkey v2.0\n#Include <adash>\n\narr := [1, 2, 3, 4, 5, 6]\nresult := _.chunk(arr, 2)\nMsgBox(result[1][1])\n"
    }
  ]
}
```

## Training Your First Model

### Step 1: Review Configuration

Edit `config/sft.yaml` to customize training:

```yaml
base_model: "openai/gpt-oss-20b"
max_seq_length: 1024
load_in_4bit: true

lora:
  r: 8
  alpha: 16
  dropout: 0.0
  target_modules:
    - q_proj
    - k_proj
    - v_proj
    - o_proj
    - gate_proj
    - up_proj
    - down_proj

training:
  num_train_epochs: 1
  per_device_train_batch_size: 1
  gradient_accumulation_steps: 4
  learning_rate: 2.0e-4
  optimizer: adamw_8bit
```

### Step 2: Start Training

```bash
python src/train_qlora.py --config config/sft.yaml
```

**Expected training time:** 2-6 hours (depends on GPU)

**Expected output:**
```
Loading model: openai/gpt-oss-20b
✓ Model loaded with 4-bit quantization
✓ LoRA adapters configured (trainable params: 0.05%)
Loading dataset from data/prepared/train_harmony.jsonl...
✓ Loaded 1,699 training examples

Training started...
Epoch 1/1
Step 100/1699 | Loss: 1.234 | LR: 1.8e-4 | ETA: 1h 23m
Step 200/1699 | Loss: 0.987 | LR: 1.6e-4 | ETA: 1h 15m
...
Step 1699/1699 | Loss: 0.432 | LR: 2.0e-5 | ETA: 0m 0s

✓ Training complete!
Model saved to: gpt-oss-finetuned/
```

### Step 3: Merge Adapters

Convert LoRA adapters to full model weights:

```bash
python src/train_qlora.py --config config/sft.yaml --merge_only 1
```

**Expected output:**
```
Loading model from gpt-oss-finetuned/...
Merging LoRA adapters...
✓ Adapters merged successfully
Saving merged model to gpt-oss-finetuned-merged/...
✓ Model saved
```

### Step 4: Convert to GGUF (Optional)

For local inference in LM Studio:

```bash
bash scripts/convert_to_gguf.sh \
    gpt-oss-finetuned-merged \
    gpt-oss-finetuned.gguf
```

## Testing Your Model

### Option 1: Python Inference

```python
from transformers import AutoModelForCausalLM, AutoTokenizer

# Load model
model = AutoModelForCausalLM.from_pretrained("gpt-oss-finetuned-merged")
tokenizer = AutoTokenizer.from_pretrained("gpt-oss-finetuned-merged")

# Generate code
prompt = "Write an AutoHotkey script that shows a message box"
inputs = tokenizer(prompt, return_tensors="pt")
outputs = model.generate(**inputs, max_length=100)
print(tokenizer.decode(outputs[0]))
```

### Option 2: LM Studio

1. Open LM Studio
2. Load `gpt-oss-finetuned.gguf`
3. Select "Harmony" template
4. Test with prompts like:
   - "Write a hotkey for Ctrl+J that shows a message"
   - "Create a GUI with a button"
   - "Read a file and display its contents"

### Option 3: Validation Dataset

Evaluate on held-out test set:

```bash
python scripts/evaluate.py \
    --model gpt-oss-finetuned-merged \
    --test-data data/prepared/test_harmony.jsonl
```

## Next Steps

Now that you have a working setup, explore:

1. **[Dataset Building](Dataset-Building.md)** - Learn advanced dataset customization
2. **[Training Guide](Training-Guide.md)** - Optimize hyperparameters
3. **[API Reference](API-Reference.md)** - Understand the codebase
4. **[Troubleshooting](Troubleshooting.md)** - Fix common issues

### Experiment Ideas

- **Add more examples** from your own AHK v2 scripts
- **Tune hyperparameters** in `config/sft.yaml`
- **Try different base models** (e.g., CodeLlama, DeepSeek)
- **Increase training epochs** for better performance
- **Add validation metrics** to track improvement

## Common First-Time Issues

### GPU Out of Memory

**Solution:** Reduce batch size or sequence length in `config/sft.yaml`:

```yaml
max_seq_length: 512  # Reduced from 1024
training:
  per_device_train_batch_size: 1
  gradient_accumulation_steps: 8  # Increased from 4
```

### Dataset Not Found

**Solution:** Ensure you've run the dataset building steps:

```bash
python -m src.build_dataset --input-dir data/raw_scripts --output-dir data/prepared
```

### Import Errors

**Solution:** Reinstall dependencies:

```bash
pip install --force-reinstall -r requirements.txt
```

### Slow Training

**Solution:** Verify GPU is being used:

```python
import torch
print(f"CUDA available: {torch.cuda.is_available()}")
print(f"GPU name: {torch.cuda.get_device_name(0)}")
```

For more issues, see [Troubleshooting](Troubleshooting.md).

---

**Congratulations!** You've completed the getting started guide. 🎉

Continue to [Dataset Building](Dataset-Building.md) to learn more about customizing your training data.
