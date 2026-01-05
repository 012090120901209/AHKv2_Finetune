"""Dataset builder for converting raw AutoHotkey snippets into JSONL pairs.

This utility walks the `data/raw_scripts` directory (or any provided source
root), normalises each snippet, and writes train/validation/test splits that
are compatible with the existing fine-tuning tooling (`prompt` / `response`
schema expected by `src/data_prep.py`).

Usage example:

    python -m src.build_dataset \
        --input-dir data/raw_scripts \
        --output-dir data/prepared \
        --train-file train.jsonl \
        --val-file val.jsonl \
        --test-file test.jsonl

The script performs basic deduplication (by snippet contents) and embeds
metadata so downstream consumers can trace every training row back to its
source file.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import random
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable, List, Sequence


DEFAULT_INPUT_DIR = Path("data/raw_scripts")
DEFAULT_OUTPUT_DIR = Path("data/prepared")


@dataclass
class SnippetRecord:
    prompt: str
    response: str
    metadata: dict


def humanise_title(stem: str) -> str:
    """Convert a filename stem into a readable label."""

    cleaned = stem.replace("_", " ")
    cleaned = cleaned.replace("-", " ")
    cleaned = re.sub(r"\s+", " ", cleaned)
    return cleaned.strip()


def build_prompt(category: str, title: str, source_path: str) -> str:
    """Craft the prompt text for the snippet."""

    title_label = humanise_title(title)
    lines = [
        "You are maintaining a knowledge base of AutoHotkey examples.",
        f"Category: {category}",
        f"Example ID: {title}",
        f"Source Path: {source_path}",
        "Return the exact AutoHotkey snippet associated with this reference.",
    ]
    return "\n".join(lines)


def iterate_snippets(root: Path) -> Iterable[SnippetRecord]:
    for path in sorted(root.rglob("*.ahk")):
        if not path.is_file():
            continue

        try:
            raw_text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            raw_text = path.read_text(encoding="utf-8", errors="replace")

        raw_text = raw_text.lstrip("\ufeff")
        snippet = raw_text.strip()
        if not snippet:
            continue

        rel_path = path.relative_to(root)
        category = rel_path.parts[0] if len(rel_path.parts) > 1 else rel_path.parent.name
        title = path.stem
        prompt = build_prompt(category, title, rel_path.as_posix())

        metadata = {
            "source_path": rel_path.as_posix(),
            "category": category,
            "filename": path.name,
            "line_count": len(snippet.splitlines()),
            "record_type": "snippet",
        }

        response = snippet.rstrip() + "\n"

        yield SnippetRecord(prompt=prompt, response=response, metadata=metadata)


def iterate_reference_elements(csv_path: Path) -> Iterable[SnippetRecord]:
    if not csv_path.exists():
        raise FileNotFoundError(f"Reference CSV not found: {csv_path}")

    with csv_path.open("r", encoding="utf-8-sig", newline="") as handle:
        reader = csv.DictReader(handle)
        for row in reader:
            name = (row.get("Name") or "").strip()
            description = (row.get("Description") or "").strip()
            if not name or not description:
                continue

            element_type = (row.get("ElementType") or "Unknown").strip() or "Unknown"
            source_file = (row.get("SourceFile") or "").strip()
            logical_path = (row.get("Path") or "").strip()

            prompt_lines = [
                "You are maintaining a knowledge base of AutoHotkey reference entries.",
                f"Element Type: {element_type}",
                f"Element Name: {name}",
            ]
            if source_file:
                prompt_lines.append(f"Source File: {source_file}")
            if logical_path:
                prompt_lines.append(f"Category Path: {logical_path}")
            prompt_lines.append("Provide the official description and any pertinent usage details.")

            prompt = "\n".join(prompt_lines)

            response_parts = [description]
            element_type_field = (row.get("Type") or "").strip()
            if element_type_field:
                response_parts.append(f"Signature Type: {element_type_field}")
            return_type = (row.get("ReturnType") or "").strip()
            if return_type:
                response_parts.append(f"Return Type: {return_type}")
            symbol = (row.get("Symbol") or "").strip()
            if symbol:
                response_parts.append(f"Symbol: {symbol}")
            parameters = (row.get("Parameters") or "").strip()
            if parameters:
                response_parts.append(f"Parameters: {parameters}")

            response = "\n".join(response_parts).strip() + "\n"

            metadata = {
                "record_type": "reference",
                "element_type": element_type,
                "name": name,
                "source_csv": csv_path.as_posix(),
                "source_file": source_file,
                "category_path": logical_path,
            }

            yield SnippetRecord(prompt=prompt, response=response, metadata=metadata)


def dedupe(records: Iterable[SnippetRecord]) -> List[SnippetRecord]:
    unique = []
    seen: set[str] = set()

    for rec in records:
        digest = hashlib.sha256(rec.response.encode("utf-8")).hexdigest()
        if digest in seen:
            continue
        seen.add(digest)
        enriched = SnippetRecord(
            prompt=rec.prompt,
            response=rec.response,
            metadata={**rec.metadata, "sha256": digest},
        )
        unique.append(enriched)

    return unique


def split_records(records: Sequence[SnippetRecord], val_ratio: float, test_ratio: float, seed: int) -> tuple[List[SnippetRecord], List[SnippetRecord], List[SnippetRecord]]:
    if not 0 <= val_ratio < 1:
        raise ValueError("val-ratio must be in [0, 1)")
    if not 0 <= test_ratio < 1:
        raise ValueError("test-ratio must be in [0, 1)")
    if val_ratio + test_ratio >= 1:
        raise ValueError("val-ratio + test-ratio must be less than 1")

    records = list(records)
    rng = random.Random(seed)
    rng.shuffle(records)

    total = len(records)
    val_count = int(total * val_ratio)
    test_count = int(total * test_ratio)
    train_count = total - val_count - test_count

    train = records[:train_count]
    val = records[train_count : train_count + val_count]
    test = records[train_count + val_count :]
    return train, val, test


def write_jsonl(path: Path, records: Iterable[SnippetRecord]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as f:
        for rec in records:
            row = {
                "prompt": rec.prompt,
                "response": rec.response,
                "metadata": rec.metadata,
            }
            f.write(json.dumps(row, ensure_ascii=False) + "\n")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Build JSONL datasets from raw AutoHotkey snippets.")
    parser.add_argument("--input-dir", type=Path, default=DEFAULT_INPUT_DIR)
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT_DIR)
    parser.add_argument("--train-file", default="train.jsonl")
    parser.add_argument("--val-file", default="val.jsonl")
    parser.add_argument("--test-file", default="test.jsonl")
    parser.add_argument("--val-ratio", type=float, default=0.1)
    parser.add_argument("--test-ratio", type=float, default=0.1)
    parser.add_argument("--seed", type=int, default=2025)
    parser.add_argument(
        "--elements-csv",
        type=Path,
        action="append",
        default=[],
        help="Optional CSV files that contain reference data (variables, classes, directives).",
    )
    parser.add_argument("--dry-run", action="store_true", help="List stats without writing any files.")
    return parser.parse_args()


def main() -> None:
    args = parse_args()

    records = list(iterate_snippets(args.input_dir))
    print(f"Loaded {len(records)} raw snippets from {args.input_dir}.")

    total_reference = 0
    for csv_path in args.elements_csv:
        references = list(iterate_reference_elements(csv_path))
        print(f"Loaded {len(references)} reference entries from {csv_path}.")
        records.extend(references)
        total_reference += len(references)

    if total_reference:
        print(f"Total records with reference data: {len(records)} (added {total_reference}).")

    unique_records = dedupe(records)
    print(f"After deduplication: {len(unique_records)} unique records.")

    train, val, test = split_records(unique_records, args.val_ratio, args.test_ratio, seed=args.seed)
    print(
        "Split sizes (train/val/test): "
        f"{len(train)}/{len(val)}/{len(test)}"
    )

    if args.dry_run:
        print("Dry run complete; no files written.")
        return

    output_dir = args.output_dir
    write_jsonl(output_dir / args.train_file, train)
    write_jsonl(output_dir / args.val_file, val)
    write_jsonl(output_dir / args.test_file, test)
    print(f"Wrote datasets to {output_dir}.")


if __name__ == "__main__":
    main()


