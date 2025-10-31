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

## Layout
- config/sft.yaml training hyperparams
- src/train_qlora.py training and merge
- src/data_prep.py converts simple prompt reply JSONL to Harmony chat JSONL
- scripts provide setup and GGUF conversion

