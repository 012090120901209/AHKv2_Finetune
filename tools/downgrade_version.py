import os

TARGET_DIR = r"C:\Users\uphol\Documents\Design\Coding\ahk-finetune\data\raw_scripts\AHK_v2_Examples"
OLD_VERSION = "#Requires AutoHotkey v2.1-alpha.16"
NEW_VERSION = "#Requires AutoHotkey v2.0"

def downgrade_version():
    count = 0
    for root, dirs, files in os.walk(TARGET_DIR):
        for file in files:
            if file.endswith(".ahk"):
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    if OLD_VERSION in content:
                        new_content = content.replace(OLD_VERSION, NEW_VERSION)
                        with open(file_path, 'w', encoding='utf-8') as f:
                            f.write(new_content)
                        count += 1
                        print(f"Updated: {file}")
                except Exception as e:
                    print(f"Error processing {file}: {e}")

    print(f"Total files updated: {count}")

if __name__ == "__main__":
    downgrade_version()
