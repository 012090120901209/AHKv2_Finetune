# OSS 20B Fine Tuning with Unsloth QLoRA

This repo fine tunes `openai/gpt-oss-20b` with Unsloth QLoRA, merges adapters to a full HF checkpoint, and optionally converts to GGUF for local inference in LM Studio or llama.cpp.

## Quick start Bash
python -m venv .venv
source .venv/bin/activate
pip install -U pip
pip install -r requirements.txt

# Prepare sample data into Harmony chat format
python src/data_prep.py --in data/samples.jsonl --out data/prepared/train.jsonl

# Train a tiny smoke test
python src/train_qlora.py --config config/sft.yaml --max_steps 30

# Merge adapters into full weights
python src/train_qlora.py --config config/sft.yaml --merge_only 1

# Optional GGUF export
bash scripts/convert_to_gguf.sh gpt-oss-finetuned-merged gpt-oss-finetuned.gguf

## Quick start PowerShell
python -m venv .venv
. .\.venv\Scripts\Activate.ps1
pip install -U pip
pip install -r requirements.txt

python .\src\data_prep.py --in .\data\samples.jsonl --out .\data\prepared\train.jsonl
python .\src\train_qlora.py --config .\config\sft.yaml --max_steps 30
python .\src\train_qlora.py --config .\config\sft.yaml --merge_only 1
.\scripts\convert_to_gguf.ps1 -InPath gpt-oss-finetuned-merged -OutPath gpt-oss-finetuned.gguf

## Run your finetune in LM Studio
1. Open LM Studio and add your GGUF file
2. Select the Harmony template if prompted
3. Start the local server and test chats

## Notes
- Keep sequence length at 1024 for low VRAM runs
- Use QLoRA defaults in config for a single 12 to 16 GB GPU
- Provide your own dataset in `data/samples.jsonl` or point `--in` at your file

## Export VS Code problems to chat
- Convert a Problems panel entry into chat-ready text: `python tools/problems_to_chat.py --index 0 --chat-file tmp/chat_context.txt`
- Emit Harmony-formatted JSONL instead of plain text: `python tools/problems_to_chat.py --match Httpserver.ahk --harmony-jsonl tmp/problems_chat.jsonl`

## Build datasets from AutoHotkey snippets
1. Verify raw snippets live under `data/raw_scripts` (OneDrive or network sync locations can cause missing files—double-check before running).
2. Generate the JSONL splits:
   - PowerShell: `python -m src.build_dataset`
   - Bash: `python -m src.build_dataset --input-dir data/raw_scripts --output-dir data/prepared`
3. Confirm the script reports train/val/test counts and that `data/prepared/train.jsonl`, `data/prepared/val.jsonl`, and `data/prepared/test.jsonl` exist.
4. Validate the files with a quick JSONL sanity check (e.g. `python -m json.tool < data/prepared/train.jsonl | head`).
5. Convert each split into Harmony chat format for training:
   - `python -m src.data_prep --in data/prepared/train.jsonl --out data/prepared/train_harmony.jsonl`
   - `python -m src.data_prep --in data/prepared/val.jsonl --out data/prepared/val_harmony.jsonl`
   - `python -m src.data_prep --in data/prepared/test.jsonl --out data/prepared/test_harmony.jsonl`
6. Run any downstream build steps (`npm run build`, config sync, data copy) so the refreshed datasets propagate through the stack.

## Layout
- config/sft.yaml training hyperparams
- src/train_qlora.py training and merge
- src/data_prep.py converts simple prompt reply JSONL to Harmony chat JSONL
- scripts provide setup and GGUF conversion

