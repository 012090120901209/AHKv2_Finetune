# Frequently Asked Questions (FAQ)

Common questions about the AHKv2_Finetune project.

## General Questions

### What is this project?

This project provides a complete pipeline for fine-tuning the `openai/gpt-oss-20b` language model on AutoHotkey v2 code examples using Unsloth QLoRA. The goal is to create a model that can generate high-quality AutoHotkey v2 code.

### Why AutoHotkey v2?

AutoHotkey v2 is a significant rewrite of AutoHotkey v1 with breaking syntax changes. There's limited training data for v2 in existing language models, making fine-tuning necessary for accurate code generation.

### Do I need a GPU?

**For training:** Yes, a CUDA-capable GPU with at least 12GB VRAM is required.

**For inference:** No, you can use the GGUF model with CPU inference in LM Studio (slower but works).

### How long does training take?

- **Full training (1 epoch):** 2-6 hours on RTX 3090
- **Smoke test (30 steps):** 2-5 minutes
- **Depends on:** GPU speed, dataset size, sequence length

### How much does it cost?

The project is open-source and free. You only need:
- Hardware (local GPU) or cloud GPU rental ($0.50-2.00/hour)
- No API costs (unlike GPT-4)

## Dataset Questions

### Where did the 1,719 examples come from?

Multiple sources:
- **Array examples (82):** Created using adash library
- **StdLib examples (95):** Created for standard library coverage
- **Advanced examples (50):** Design patterns and OOP
- **GitHub examples (6):** Real-world repositories
- **Converter test suite:** Extracted from AHK v1→v2 converter

See `research/EXAMPLES_SUMMARY.md` for full details.

### Can I add my own examples?

Yes! Add `.ahk` files to `data/raw_scripts/` and rebuild:

```bash
python -m src.build_dataset \
    --input-dir data/raw_scripts \
    --output-dir data/prepared
```

### Why are some #Include directives broken?

Many examples use external libraries like `<adash>`, `<CLR>`, `<winrt.ahk>` that aren't included in the repository. These demonstrate library usage patterns and are intentional. The model learns the syntax even without the actual library files.

### What's the train/val/test split?

- **Train:** 80% (1,699 examples)
- **Validation:** 10% (212 examples)
- **Test:** 10% (212 examples)

You can customize this with `--val-ratio` and `--test-ratio` flags.

### Are there duplicates in the dataset?

No, the build_dataset script automatically deduplicates using SHA256 hashing. From 1,719 files, 16 duplicates were removed, leaving 1,703 unique examples.

## Training Questions

### What is QLoRA?

QLoRA (Quantized Low-Rank Adaptation) is an efficient fine-tuning method that:
- Uses **4-bit quantization** to reduce memory
- Trains only **0.05% of parameters** (LoRA adapters)
- Achieves **similar performance** to full fine-tuning
- Enables training on **consumer GPUs** (12-16GB VRAM)

### What does "merge adapters" mean?

During QLoRA training, only small adapter weights are trained. "Merging" combines these adapters with the base model to create a standalone model that doesn't require loading adapters separately.

### Can I use a different base model?

Yes! Edit `config/sft.yaml`:

```yaml
base_model: "codellama/CodeLlama-7b-hf"  # or other model
```

Compatible models:
- `openai/gpt-oss-20b` (default)
- `codellama/CodeLlama-7b-hf`
- `deepseek-ai/deepseek-coder-6.7b-base`
- Any HuggingFace causal language model

### How do I know if training is working?

Watch the loss value - it should decrease over time:

```
Step 100/1699 | Loss: 1.234  ← Starting loss
Step 500/1699 | Loss: 0.987  ← Decreasing (good!)
Step 1000/1699 | Loss: 0.654  ← Still decreasing
Step 1699/1699 | Loss: 0.432  ← Final loss (lower is better)
```

If loss is:
- **Decreasing:** Training is working ✅
- **NaN or Inf:** Problem with learning rate or data ❌
- **Not changing:** Learning rate too low or data issue ⚠️

### Should I train for more epochs?

**1 epoch** (default) is usually sufficient for this dataset size. More epochs may lead to overfitting.

**To increase epochs:**
```yaml
# config/sft.yaml
training:
  num_train_epochs: 3  # Try 2-3 epochs max
```

Monitor validation loss - if it starts increasing, you're overfitting.

### What hyperparameters should I tune?

Start with these (in order of impact):

1. **Learning rate:** Try 1e-4 to 5e-4
2. **LoRA rank (r):** Try 4, 8, or 16
3. **Max sequence length:** Try 512, 1024, or 2048
4. **Batch size:** Adjust based on GPU memory

## Model Usage Questions

### How do I use the fine-tuned model?

**Option 1: Python**
```python
from transformers import AutoModelForCausalLM, AutoTokenizer

model = AutoModelForCausalLM.from_pretrained("gpt-oss-finetuned-merged")
tokenizer = AutoTokenizer.from_pretrained("gpt-oss-finetuned-merged")

prompt = "Write a hotkey for Ctrl+J"
inputs = tokenizer(prompt, return_tensors="pt")
outputs = model.generate(**inputs, max_length=100)
print(tokenizer.decode(outputs[0]))
```

**Option 2: LM Studio**
1. Convert to GGUF: `bash scripts/convert_to_gguf.sh ...`
2. Load in LM Studio
3. Chat with the model

### What format should prompts use?

The model was trained with prompts like:

```
You are maintaining a knowledge base of AutoHotkey examples.
Category: Hotkeys
Example ID: Hotkey_CtrlJ
Return the exact AutoHotkey snippet associated with this reference.
```

For code generation, simpler prompts work too:

```
Write an AutoHotkey script that shows a message box when pressing Ctrl+J
```

### Can I quantize the model further?

Yes, after merging you can quantize to smaller sizes:

```bash
# GGUF supports multiple quantization levels
# Q4_K_M (recommended, good quality/size balance)
# Q5_K_M (better quality, larger size)
# Q8_0 (best quality, largest size)
```

### How accurate is the fine-tuned model?

Accuracy depends on:
- Training quality (loss values)
- Base model capabilities
- Prompt format
- Example coverage in training data

Expect **good performance** on:
- Syntax structures seen in training
- Common AutoHotkey patterns
- Standard library usage

Expect **limited performance** on:
- Very new AHK v2 features not in examples
- Complex multi-file projects
- Domain-specific automation tasks

## Technical Questions

### Why use Unsloth?

Unsloth provides:
- **2x faster training** than standard methods
- **50% less memory** usage
- **Easy QLoRA setup** with minimal code
- **Good documentation** and examples

### What's the Harmony chat format?

Harmony is a conversational format used by some language models:

```json
{
  "messages": [
    {"role": "system", "content": "You are a helpful assistant."},
    {"role": "user", "content": "User's question"},
    {"role": "assistant", "content": "Assistant's response"}
  ]
}
```

### Why is elements.csv needed?

`elements.csv` contains 444 reference entries from official AutoHotkey documentation. Merging this with code examples provides:
- **Richer context** about built-in functions
- **Documentation-style** responses
- **Formal descriptions** alongside code examples

### Can I train on CPU?

Training on CPU is **not recommended** because:
- **Extremely slow** (100x+ slower than GPU)
- **Large memory requirements** (64GB+ RAM)
- **May not fit in memory** without quantization

For inference (using the model), CPU works fine but is slower.

### What Python version is required?

- **Minimum:** Python 3.8
- **Recommended:** Python 3.10 or 3.11
- **Not supported:** Python 3.7 or earlier, Python 3.12+ (may have compatibility issues)

## Contribution Questions

### How can I contribute?

Ways to contribute:
1. **Add more examples** - Submit PRs with new .ahk files
2. **Improve documentation** - Fix typos, add clarifications
3. **Report issues** - Found a bug? Open an issue
4. **Share results** - Trained a good model? Share config and results
5. **Add features** - Validation scripts, evaluation metrics, etc.

### I found a bug, what should I do?

1. **Check FAQ and Troubleshooting** first
2. **Search existing issues** on GitHub
3. **Open a new issue** with:
   - Clear description of the problem
   - Steps to reproduce
   - Error messages (full stack trace)
   - System info (OS, Python version, GPU)

### Can I use this for commercial purposes?

Check the LICENSE file and the licenses of:
- Base model (`openai/gpt-oss-20b`)
- Dependencies (transformers, torch, unsloth)
- AutoHotkey code in examples

**Generally:** Open source licenses allow commercial use with attribution.

## Performance Questions

### How do I evaluate model quality?

Methods:
1. **Manual testing** - Try various prompts and check output
2. **Hold-out test set** - Evaluate on unseen examples
3. **Code execution** - Run generated code in AutoHotkey
4. **Syntax validation** - Check for syntax errors
5. **Human review** - Expert evaluation of code quality

### Can the model generate working code?

The model can generate:
- ✅ **Syntactically correct** AHK v2 code (usually)
- ✅ **Common patterns** from training data
- ✅ **Standard library usage**
- ⚠️ **Complex logic** (may have bugs)
- ❌ **Domain expertise** (limited to training data)

Always review and test generated code before use.

### How does it compare to GPT-4?

| Aspect | GPT-4 | Fine-tuned Model |
|--------|-------|------------------|
| AHK v2 syntax | Good (v1 biased) | Excellent (v2 native) |
| General knowledge | Excellent | Limited to code |
| Cost | $0.01-0.03/1K tokens | Free (after training) |
| Offline use | No | Yes (GGUF) |
| Customization | Prompt engineering | Full fine-tuning |

## Future Plans

### What's next for this project?

Potential improvements:
- **Evaluation suite** with automated testing
- **Larger datasets** from more repositories
- **Multi-model support** (CodeLlama, DeepSeek, etc.)
- **Interactive demo** with Gradio UI
- **Benchmark results** comparing models
- **Pre-trained models** on HuggingFace Hub

### Can I help?

Yes! See [Contributing](#contribution-questions) above.

## Still Have Questions?

- **Documentation:** Check [wiki pages](Home.md)
- **Troubleshooting:** See [Troubleshooting Guide](Troubleshooting.md)
- **Issues:** Search [GitHub Issues](https://github.com/012090120901209/AHKv2_Finetune/issues)
- **Contact:** Open a new issue for questions

---

**Last Updated:** 2025-11-19
