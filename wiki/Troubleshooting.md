# Troubleshooting Guide

Common issues and solutions for the AHKv2_Finetune project.

## Table of Contents

1. [Installation Issues](#installation-issues)
2. [Dataset Building Issues](#dataset-building-issues)
3. [Training Issues](#training-issues)
4. [GPU & Memory Issues](#gpu--memory-issues)
5. [Model Loading Issues](#model-loading-issues)
6. [Testing Issues](#testing-issues)

## Installation Issues

### Problem: `pip install -r requirements.txt` fails

**Symptoms:**
```
ERROR: Could not find a version that satisfies the requirement...
```

**Solutions:**

1. **Upgrade pip:**
   ```bash
   pip install --upgrade pip
   ```

2. **Use Python 3.10+:**
   ```bash
   python --version  # Should be 3.10 or higher
   ```

3. **Install with verbose output:**
   ```bash
   pip install -v -r requirements.txt
   ```

4. **Try without cache:**
   ```bash
   pip install --no-cache-dir -r requirements.txt
   ```

### Problem: CUDA not found

**Symptoms:**
```python
torch.cuda.is_available()  # Returns False
```

**Solutions:**

1. **Check NVIDIA driver:**
   ```bash
   nvidia-smi
   ```

2. **Install CUDA toolkit:**
   - Download from [NVIDIA CUDA Downloads](https://developer.nvidia.com/cuda-downloads)
   - Install CUDA 11.8 or 12.1

3. **Install correct PyTorch:**
   ```bash
   pip install torch --index-url https://download.pytorch.org/whl/cu118
   ```

4. **Verify installation:**
   ```python
   import torch
   print(torch.cuda.is_available())
   print(torch.version.cuda)
   ```

## Dataset Building Issues

### Problem: No .ahk files found

**Symptoms:**
```
Loaded 0 raw snippets from data/raw_scripts.
```

**Solutions:**

1. **Check directory structure:**
   ```bash
   ls -la data/raw_scripts/AHK_v2_Examples/
   ```

2. **Count .ahk files:**
   ```bash
   find data/raw_scripts -name "*.ahk" | wc -l
   # Expected: 1719
   ```

3. **Check file extension:**
   - Files must end with `.ahk` (not `.ah2` or `.txt`)
   - Run: `ls data/raw_scripts/AHK_v2_Examples/*.ahk | head -10`

4. **Verify path:**
   ```bash
   python -m src.build_dataset --input-dir data/raw_scripts --dry-run
   ```

### Problem: Empty dataset after deduplication

**Symptoms:**
```
After deduplication: 0 unique records.
```

**Solutions:**

1. **Check file contents:**
   ```bash
   head -20 data/raw_scripts/AHK_v2_Examples/Array_01_Chunk.ahk
   ```

2. **Files might be empty:**
   ```bash
   find data/raw_scripts -name "*.ahk" -empty
   ```

3. **Unicode encoding issues:**
   - Files must be UTF-8 encoded
   - Check with: `file data/raw_scripts/AHK_v2_Examples/*.ahk | head`

### Problem: CSV file not found

**Symptoms:**
```
FileNotFoundError: Reference CSV not found: data/elements.csv
```

**Solutions:**

1. **Verify CSV exists:**
   ```bash
   ls -la data/elements.csv
   ```

2. **Run without CSV:**
   ```bash
   python -m src.build_dataset \
       --input-dir data/raw_scripts \
       --output-dir data/prepared
   # Don't use --elements-csv flag
   ```

3. **Check CSV format:**
   ```bash
   head data/elements.csv
   # Should have header: Name,Description,ElementType,...
   ```

## Training Issues

### Problem: Training won't start

**Symptoms:**
```
FileNotFoundError: [Errno 2] No such file or directory: 'data/prepared/train_harmony.jsonl'
```

**Solutions:**

1. **Build dataset first:**
   ```bash
   # Step 1: Build dataset
   python -m src.build_dataset \
       --input-dir data/raw_scripts \
       --output-dir data/prepared

   # Step 2: Convert to Harmony format
   python -m src.data_prep \
       --in data/prepared/train.jsonl \
       --out data/prepared/train_harmony.jsonl
   ```

2. **Check files exist:**
   ```bash
   ls -lh data/prepared/
   # Should see train_harmony.jsonl, val_harmony.jsonl
   ```

### Problem: Training stops with error

**Symptoms:**
```
RuntimeError: CUDA out of memory
```

**Solution:** See [GPU & Memory Issues](#gpu--memory-issues)

### Problem: Loss is NaN

**Symptoms:**
```
Step 100/1699 | Loss: nan | LR: 1.8e-4
```

**Solutions:**

1. **Reduce learning rate:**
   ```yaml
   # config/sft.yaml
   training:
     learning_rate: 5.0e-5  # Reduced from 2.0e-4
   ```

2. **Check data quality:**
   ```bash
   # Verify JSONL is valid
   python -c "import json; [json.loads(line) for line in open('data/prepared/train_harmony.jsonl')]"
   ```

3. **Reduce batch size:**
   ```yaml
   training:
     per_device_train_batch_size: 1
     gradient_accumulation_steps: 8
   ```

## GPU & Memory Issues

### Problem: CUDA out of memory

**Symptoms:**
```
RuntimeError: CUDA out of memory. Tried to allocate 2.00 GiB
```

**Solutions (in order of effectiveness):**

1. **Reduce max sequence length:**
   ```yaml
   # config/sft.yaml
   max_seq_length: 512  # Reduced from 1024
   ```

2. **Use smaller batch size:**
   ```yaml
   training:
     per_device_train_batch_size: 1  # Minimum
     gradient_accumulation_steps: 8  # Increase to compensate
   ```

3. **Enable gradient checkpointing:**
   ```yaml
   training:
     gradient_checkpointing: true
   ```

4. **Use 4-bit quantization:**
   ```yaml
   load_in_4bit: true  # Already enabled by default
   ```

5. **Reduce LoRA rank:**
   ```yaml
   lora:
     r: 4  # Reduced from 8
     alpha: 8  # Reduced from 16
   ```

6. **Clear CUDA cache:**
   ```python
   import torch
   torch.cuda.empty_cache()
   ```

### Problem: GPU not being used

**Symptoms:**
```
Training is very slow (>10 hours expected)
nvidia-smi shows 0% GPU utilization
```

**Solutions:**

1. **Verify CUDA availability:**
   ```python
   import torch
   print(f"CUDA available: {torch.cuda.is_available()}")
   print(f"CUDA device: {torch.cuda.get_device_name(0)}")
   ```

2. **Check PyTorch CUDA version:**
   ```python
   import torch
   print(torch.version.cuda)
   # Should match your CUDA driver version
   ```

3. **Reinstall PyTorch with CUDA:**
   ```bash
   pip uninstall torch
   pip install torch --index-url https://download.pytorch.org/whl/cu118
   ```

### Problem: Multiple GPUs not detected

**Solutions:**

1. **Check all GPUs:**
   ```bash
   nvidia-smi -L
   ```

2. **Specify GPU in config:**
   ```yaml
   training:
     local_rank: 0  # Use first GPU
   ```

3. **Use DataParallel:**
   ```python
   model = torch.nn.DataParallel(model)
   ```

## Model Loading Issues

### Problem: Model not found after training

**Symptoms:**
```
OSError: gpt-oss-finetuned/ does not appear to be a valid checkpoint
```

**Solutions:**

1. **Check model directory:**
   ```bash
   ls -la gpt-oss-finetuned/
   # Should contain: adapter_config.json, adapter_model.bin, ...
   ```

2. **Training may have failed:**
   - Check training logs for errors
   - Re-run training with verbose output

3. **Use absolute path:**
   ```python
   model_path = "/home/user/AHKv2_Finetune/gpt-oss-finetuned"
   model = AutoModelForCausalLM.from_pretrained(model_path)
   ```

### Problem: Merged model won't load

**Symptoms:**
```
Error loading merged model
```

**Solutions:**

1. **Re-merge adapters:**
   ```bash
   python src/train_qlora.py --config config/sft.yaml --merge_only 1
   ```

2. **Check merged directory:**
   ```bash
   ls -la gpt-oss-finetuned-merged/
   # Should contain: config.json, pytorch_model.bin, tokenizer files
   ```

3. **Use correct path:**
   ```python
   # Load merged model, not adapter model
   model = AutoModelForCausalLM.from_pretrained("gpt-oss-finetuned-merged")
   ```

## Testing Issues

### Problem: Tests fail with ImportError

**Symptoms:**
```
ImportError: cannot import name 'build_dataset'
```

**Solutions:**

1. **Run from project root:**
   ```bash
   cd /home/user/AHKv2_Finetune
   python -m unittest discover tests -v
   ```

2. **Install in editable mode:**
   ```bash
   pip install -e .
   ```

3. **Add to PYTHONPATH:**
   ```bash
   export PYTHONPATH=/home/user/AHKv2_Finetune:$PYTHONPATH
   python -m unittest discover tests -v
   ```

### Problem: Specific test fails

**Solutions:**

1. **Run single test for details:**
   ```bash
   python -m unittest tests.test_build_dataset.TestDedupe.test_removes_duplicates -v
   ```

2. **Check test dependencies:**
   ```bash
   # Tests require these files
   ls data/raw_scripts/
   ls data/elements.csv
   ```

3. **Clean and retry:**
   ```bash
   # Remove test artifacts
   rm -rf tests/__pycache__
   python -m unittest discover tests -v
   ```

## General Debugging

### Enable Verbose Logging

```python
import logging
logging.basicConfig(level=logging.DEBUG)
```

### Check System Info

```python
import torch
import transformers
import sys

print(f"Python: {sys.version}")
print(f"PyTorch: {torch.__version__}")
print(f"Transformers: {transformers.__version__}")
print(f"CUDA available: {torch.cuda.is_available()}")
if torch.cuda.is_available():
    print(f"CUDA version: {torch.version.cuda}")
    print(f"GPU: {torch.cuda.get_device_name(0)}")
    print(f"GPU memory: {torch.cuda.get_device_properties(0).total_memory / 1e9:.2f} GB")
```

### Create Minimal Reproduction

```python
# Test dataset building in isolation
from pathlib import Path
from src.build_dataset import iterate_snippets

root = Path("data/raw_scripts")
records = list(iterate_snippets(root))
print(f"Found {len(records)} examples")
```

## Getting Help

If you're still stuck:

1. **Check logs:** Look for error messages and stack traces
2. **Search issues:** [GitHub Issues](https://github.com/012090120901209/AHKv2_Finetune/issues)
3. **Enable debug mode:** Add `--verbose` flag to commands
4. **Ask for help:** Open a new issue with:
   - Error message (full stack trace)
   - Steps to reproduce
   - System information (OS, Python version, GPU)
   - What you've tried so far

---

**Related Documentation:**
- [Getting Started](Getting-Started.md) - Setup guide
- [FAQ](FAQ.md) - Common questions
- [Dataset Building](Dataset-Building.md) - Dataset issues
