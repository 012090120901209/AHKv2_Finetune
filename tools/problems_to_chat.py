import argparse
import json
from pathlib import Path

SEVERITY_MAP = {8: "error", 4: "warning", 2: "info", 1: "hint"}


def load_problems(path: Path):
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError:
        raise SystemExit(f"Problems file not found: {path}")
    except json.JSONDecodeError as exc:
        raise SystemExit(f"Problems file is not valid JSON: {exc}")

    if not isinstance(data, list):
        raise SystemExit("Problems file must contain a JSON array.")
    return data


def select_problem(problems, index=None, match=None):
    if index is not None:
        if index < 0 or index >= len(problems):
            raise SystemExit(f"Index {index} out of range (0-{len(problems) - 1}).")
        return problems[index]

    if match:
        needle = match.lower()
        for item in problems:
            if needle in str(item.get("resource", "")).lower():
                return item
        raise SystemExit(f"No problem entry found matching '{match}'.")

    raise SystemExit("Provide --index or --match to pick a problem.")


def normalize_resource(resource: str) -> Path:
    cleaned = resource.replace("\\", "/")
    if cleaned.startswith("/") and len(cleaned) > 2 and cleaned[2] == ":":
        cleaned = cleaned[1:]
    return Path(cleaned)


def severity_label(value):
    return SEVERITY_MAP.get(value, str(value))


def format_span(problem) -> str:
    start_line = problem.get("startLineNumber", "?")
    start_col = problem.get("startColumn", "?")
    end_line = problem.get("endLineNumber", start_line)
    end_col = problem.get("endColumn", start_col)
    return f"L{start_line}:C{start_col}-L{end_line}:C{end_col}"


def snippet_text(path: Path, line_number: int, context: int) -> str:
    if not path.exists():
        return "File not found; no snippet available."

    try:
        lines = path.read_text(encoding="utf-8").splitlines()
    except UnicodeDecodeError:
        lines = path.read_text(encoding="utf-8", errors="replace").splitlines()

    zero_idx = max(line_number - 1, 0)
    start = max(zero_idx - context, 0)
    end = min(zero_idx + context + 1, len(lines))

    snippet_lines = []
    for idx in range(start, end):
        marker = ">" if idx == zero_idx else " "
        snippet_lines.append(f"{marker} {idx + 1:04d} {lines[idx]}")
    return "\n".join(snippet_lines)


def build_chat_chunk(problem, context: int) -> tuple[str, Path]:
    resource = problem.get("resource", "")
    path = normalize_resource(resource)
    span = format_span(problem)
    severity = severity_label(problem.get("severity"))
    message = problem.get("message", "").strip()
    snippet = ""
    if problem.get("startLineNumber"):
        snippet = snippet_text(path, int(problem["startLineNumber"]), context)

    lines = [
        f"File: {path}",
        f"Severity: {severity}",
        f"Message: {message or '<no message>'}",
        f"Range: {span}",
    ]

    origin = problem.get("origin")
    if origin:
        lines.append(f"Origin: {origin}")

    if snippet:
        lines.append("Code:")
        lines.append(snippet)

    return "\n".join(lines).strip(), path


def append_text(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("a", encoding="utf-8") as handle:
        handle.write(text.strip() + "\n\n")


def append_harmony_jsonl(path: Path, user_content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        "messages": [
            {"role": "system", "content": "You are a helpful assistant fixing AutoHotkey issues from diagnostics."},
            {"role": "user", "content": user_content},
        ]
    }
    with path.open("a", encoding="utf-8") as handle:
        handle.write(json.dumps(payload, ensure_ascii=False) + "\n")


def main():
    parser = argparse.ArgumentParser(description="Add a problem entry to a chat-friendly text file.")
    parser.add_argument("--problems", type=Path, default=Path("data/ProblemsLog.json"), help="Path to ProblemsLog.json.")

    selector = parser.add_mutually_exclusive_group(required=True)
    selector.add_argument("--index", type=int, help="Zero-based index of the problem to export.")
    selector.add_argument("--match", help="Case-insensitive substring to match against the resource path.")

    parser.add_argument("--context", type=int, default=2, help="Lines of context to include around the error line.")
    parser.add_argument("--chat-file", type=Path, help="Optional path to append plain-text chat context.")
    parser.add_argument("--harmony-jsonl", type=Path, help="Optional path to append Harmony chat JSONL.")
    args = parser.parse_args()

    problems = load_problems(args.problems)
    problem = select_problem(problems, index=args.index, match=args.match)
    chat_chunk, source_path = build_chat_chunk(problem, context=args.context)

    if args.chat_file:
        append_text(args.chat_file, chat_chunk)
        print(f"Appended problem from {source_path} to {args.chat_file}")

    if args.harmony_jsonl:
        append_harmony_jsonl(args.harmony_jsonl, chat_chunk)
        print(f"Appended Harmony chat row to {args.harmony_jsonl}")

    if not args.chat_file and not args.harmony_jsonl:
        print(chat_chunk)


if __name__ == "__main__":
    main()
