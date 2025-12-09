import os
import re
import sys

TARGET_DIR = r"C:\Users\uphol\Documents\Design\Coding\ahk-finetune\data\raw_scripts\AHK_v2_Examples"

def fix_file(file_path):
    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
        lines = f.readlines()

    new_lines = []
    i = 0
    while i < len(lines):
        line = lines[i].rstrip()
        
        # Skip empty lines at the start (optional, but good for cleanup)
        # if not new_lines and not line:
        #     i += 1
        #     continue

        # 1. Fix Brace Style: Move standalone '{' to previous line
        # Check if current line is just '{' (with optional whitespace)
        if re.match(r'^\s*\{\s*$', line):
            # Check if previous line is a control flow statement
            if new_lines:
                prev_line = new_lines[-1]
                # If prev line doesn't end with { and is a control statement
                if re.search(r'^\s*(for|loop|if|else|while|try|catch|finally)\b', prev_line, re.IGNORECASE) and not prev_line.strip().endswith('{'):
                    new_lines[-1] = prev_line + " {"
                    i += 1
                    continue
        
        # 2. Expand One-Line Blocks: '{ statement' -> '{\n statement'
        # Example: { ActiveControlList . = ...
        match_brace_content = re.match(r'^(\s*)\{\s*(.+)$', line)
        if match_brace_content:
            indent = match_brace_content.group(1)
            content = match_brace_content.group(2)
            # Make sure it's not an object literal like x := { a: 1 }
            # Heuristic: If the line starts with {, it's likely a block. If it's x := {, it's an object.
            # The regex ^\s*\{ ensures we only catch lines starting with {.
            
            # Check if it ends with }
            if content.endswith('}'):
                content = content[:-1].strip()
                new_lines.append(f"{indent}{{\n")
                new_lines.append(f"{indent}    {content}\n")
                new_lines.append(f"{indent}}}\n")
            else:
                new_lines.append(f"{indent}{{\n")
                new_lines.append(f"{indent}    {content}\n")
            i += 1
            continue

        # 3. Fix Concatenation Spacing: ' . = ' -> ' .= '
        if ' . =' in line:
            line = line.replace(' . =', ' .=')
        
        # 4. Split multiple statements on one line
        if ') if (' in line:
            parts = line.split(') if (')
            new_lines.append(parts[0] + ")\n")
            indent = re.match(r'^\s*', line).group(0)
            
            # Check for trailing break/return/continue
            if_part = f"if ({parts[1]}"
            match_simple_stmt = re.match(r'^(if\s*\(.+\))\s+(break|return|continue)\s*$', if_part)
            if match_simple_stmt:
                new_lines.append(f"{indent}{match_simple_stmt.group(1)}\n")
                new_lines.append(f"{indent}    {match_simple_stmt.group(2)}\n")
            else:
                new_lines.append(f"{indent}{if_part}\n")
            i += 1
            continue

        new_lines.append(line + "\n")
        i += 1

    # 5. Indentation Pass
    final_lines = []
    indent_level = 0
    indent_str = "    " # 4 spaces
    
    for line in new_lines:
        stripped = line.strip()
        
        # Adjust indent for closing brace
        if stripped.startswith('}'):
            indent_level = max(0, indent_level - 1)
        
        # Apply indent
        if stripped:
            final_lines.append((indent_str * indent_level) + stripped + "\n")
        else:
            final_lines.append("\n")
            
        # Adjust indent for opening brace
        if stripped.endswith('{'):
            indent_level += 1
            
        # One-line if/loop without braces? (Not handling complex cases yet)

    # 6. Directive Spacing
    # Ensure blank line after #Requires or #SingleInstance if followed by code
    result_lines = []
    for j, line in enumerate(final_lines):
        result_lines.append(line)
        if line.strip().startswith('#') and j + 1 < len(final_lines):
            next_line = final_lines[j+1].strip()
            if next_line and not next_line.startswith('#') and not next_line.startswith(';'):
                result_lines.append("\n")

    return "".join(result_lines)

def main():
    # Test on specific file first
    # test_file = os.path.join(TARGET_DIR, "Window_WinGet_ex3.ahk")
    # if os.path.exists(test_file):
    #     print(f"Formatting {test_file}...")
    #     new_content = fix_file(test_file)
    #     with open(test_file, 'w', encoding='utf-8') as f:
    #         f.write(new_content)
    #     print("Done.")

    # Run on all files
    print(f"Scanning {TARGET_DIR}...")
    count = 0
    for root, dirs, files in os.walk(TARGET_DIR):
        for file in files:
            if file.endswith(".ahk"):
                path = os.path.join(root, file)
                try:
                    content = fix_file(path)
                    with open(path, 'w', encoding='utf-8') as f:
                        f.write(content)
                    print(f"Formatted {file}")
                    count += 1
                except Exception as e:
                    print(f"Error formatting {file}: {e}")
    print(f"Finished formatting {count} files.")

if __name__ == "__main__":
    main()
