import json
import argparse
from pathlib import Path


def to_harmony(prompt, response):
    return {
        "messages": [
            {"role": "system", "content": "Reasoning medium. You are a helpful assistant."},
            {"role": "user", "content": prompt.strip()},
            {"role": "assistant", "content": response.strip()},
        ]
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--in", dest="inp", required=True)
    ap.add_argument("--out", dest="outp", required=True)
    args = ap.parse_args()

    out_path = Path(args.outp)
    out_path.parent.mkdir(parents=True, exist_ok=True)

    with open(args.inp, "r", encoding="utf-8") as f_in, open(out_path, "w", encoding="utf-8") as f_out:
        for line in f_in:
            if not line.strip():
                continue
            row = json.loads(line)
            ex = to_harmony(row["prompt"], row["response"])
            f_out.write(json.dumps(ex, ensure_ascii=False) + "\n")


if __name__ == "__main__":
    main()

