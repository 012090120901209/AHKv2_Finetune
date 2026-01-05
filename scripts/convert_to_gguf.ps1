param(
  [string]$InPath = "gpt-oss-finetuned-merged",
  [string]$OutPath = "gpt-oss-finetuned.gguf"
)
if (-not (Test-Path ".\llama.cpp")) {
  git clone https://github.com/ggerganov/llama.cpp.git
}
python .\llama.cpp\convert_hf_to_gguf.py $InPath --outfile $OutPath
Write-Host "Wrote $OutPath"

