import os

TARGET_DIR = r"C:\Users\uphol\Documents\Design\Coding\ahk-finetune\data\raw_scripts\AHK_v2_Examples"
INCLUDE_LINE = "#Include JSON.ahk"

def add_json_include():
    count = 0
    for root, dirs, files in os.walk(TARGET_DIR):
        for file in files:
            if file.endswith(".ahk"):
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    # Check if JSON is used but not included
                    if ("JSON." in content or "JSON " in content) and \
                       ("class JSON" not in content) and \
                       ("#Include JSON.ahk" not in content) and \
                       ("#Include <JSON>" not in content):
                        
                        lines = content.splitlines()
                        # Find insertion point (after #Requires or #SingleInstance)
                        insert_idx = 0
                        for i, line in enumerate(lines):
                            if line.strip().startswith("#Requires") or line.strip().startswith("#SingleInstance"):
                                insert_idx = i + 1
                            elif line.strip() == "":
                                continue
                            elif line.strip().startswith(";"):
                                continue
                            else:
                                # Found code or other directive, stop here if we haven't found a better spot
                                if insert_idx == 0: insert_idx = i
                                break
                        
                        lines.insert(insert_idx, INCLUDE_LINE)
                        new_content = "\n".join(lines)
                        
                        with open(file_path, 'w', encoding='utf-8') as f:
                            f.write(new_content)
                        count += 1
                        print(f"Updated: {file}")
                except Exception as e:
                    print(f"Error processing {file}: {e}")

    print(f"Total files updated: {count}")

if __name__ == "__main__":
    add_json_include()
