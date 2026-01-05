#!/usr/bin/env bash
set -euo pipefail
IN=${1:-gpt-oss-finetuned-merged}
OUT=${2:-gpt-oss-finetuned.gguf}

if [ ! -d llama.cpp ]; then
  git clone https://github.com/ggerganov/llama.cpp.git
fi

python3 llama.cpp/convert_hf_to_gguf.py "$IN" --outfile "$OUT"
echo "Wrote $OUT"

