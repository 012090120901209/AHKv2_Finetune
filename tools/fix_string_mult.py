import os
import re

TARGET_DIR = r"C:\Users\uphol\Documents\Design\Coding\ahk-finetune\data\raw_scripts\AHK_v2_Examples"

def fix_string_mult():
    count = 0
    # Regex for "char" * num or 'char' * num
    # Captures: 1=quote, 2=char, 3=num
    regex = re.compile(r'(["\'])(.)\1\s*\*\s*(\d+)')
    
    # Also handle the specific case in the logs: `OutputDebug("`n" "=" * 70 "`n")`
    # The regex above matches `"=" * 70`.
    
    for root, dirs, files in os.walk(TARGET_DIR):
        for file in files:
            if file.endswith(".ahk"):
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    new_content = content
                    
                    def replacement(m):
                        char = m.group(2)
                        num = m.group(3)
                        # Escape char if needed for Format string?
                        # Format specifiers: {index:flags width}
                        # If char is special, might be issue. But usually it's = or - or *.
                        return f'Format("{{:{char}<{num}}}", "")'

                    if regex.search(new_content):
                        new_content = regex.sub(replacement, new_content)
                        
                        with open(file_path, 'w', encoding='utf-8') as f:
                            f.write(new_content)
                        count += 1
                        print(f"Updated: {file}")
                except Exception as e:
                    print(f"Error processing {file}: {e}")

    print(f"Total files updated: {count}")

if __name__ == "__main__":
    fix_string_mult()
