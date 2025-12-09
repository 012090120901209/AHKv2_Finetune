import os
import re

TARGET_DIR = r"C:\Users\uphol\Documents\Design\Coding\ahk-finetune\data\raw_scripts\AHK_v2_Examples"

def fix_nested_classes():
    count = 0
    for root, dirs, files in os.walk(TARGET_DIR):
        for file in files:
            if file.endswith(".ahk"):
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        lines = f.readlines()
                    
                    new_lines = []
                    moved_classes = []
                    
                    i = 0
                    while i < len(lines):
                        line = lines[i]
                        # Check for class definition
                        # Assuming class definition is on one line like "class Name {" or "class Name"
                        # And it's indented (meaning it's inside something, likely a function)
                        match = re.match(r'^(\s+)class\s+(\w+)', line)
                        if match:
                            indent = match.group(1)
                            class_name = match.group(2)
                            
                            # Check if it's inside a function (heuristic: indentation > 0)
                            if len(indent) > 0:
                                # Found a nested class. Extract it.
                                class_lines = [line]
                                brace_count = line.count('{') - line.count('}')
                                
                                j = i + 1
                                while j < len(lines) and brace_count > 0:
                                    l = lines[j]
                                    brace_count += l.count('{') - l.count('}')
                                    class_lines.append(l)
                                    j += 1
                                
                                if brace_count == 0:
                                    # Successfully extracted class
                                    print(f"Moving class {class_name} from {file}")
                                    moved_classes.extend(["\n", f"; Moved class {class_name} from nested scope\n"])
                                    # Remove indentation from class lines
                                    dedented_lines = []
                                    for cl in class_lines:
                                        if cl.startswith(indent):
                                            dedented_lines.append(cl[len(indent):])
                                        else:
                                            dedented_lines.append(cl) # Should not happen if indented correctly
                                    
                                    moved_classes.extend(dedented_lines)
                                    i = j # Skip these lines
                                    continue
                        
                        new_lines.append(line)
                        i += 1
                    
                    if moved_classes:
                        new_lines.extend(moved_classes)
                        with open(file_path, 'w', encoding='utf-8') as f:
                            f.writelines(new_lines)
                        count += 1
                        
                except Exception as e:
                    print(f"Error processing {file}: {e}")

    print(f"Total files updated: {count}")

if __name__ == "__main__":
    fix_nested_classes()
