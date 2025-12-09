import os
import re

TARGET_DIR = r"C:\Users\uphol\Documents\Design\Coding\ahk-finetune\data\raw_scripts\AHK_v2_Examples"

def fix_concatenation():
    count = 0
    # Regex to find: #SingleInstance Force ; ... <code>
    # Captures: 1=Prefix (including comment), 2=Code
    # We look for #SingleInstance Force, then a semicolon, then anything, then code.
    # But we need to be careful not to match just a comment.
    # If the line ends with a comment, it's fine.
    # The issue is when code follows the comment on the same line.
    # Example: #SingleInstance Force ; comment a := 1
    
    # New regex: Match #SingleInstance Force, then optional whitespace, then ;, then optional content, then CODE.
    # But how to distinguish code from comment?
    # In the observed cases, it seems to be: #SingleInstance Force ; ... .ah2 <code>
    # OR #SingleInstance Force ; <code> (if code was commented out by the ;?)
    # Wait, in File_FileAppend_ex12.ahk: #SingleInstance Force ; MyVar := "joe"
    # Here "MyVar := "joe"" IS the code, but it is commented out by the ;.
    # So the user wants to UNCOMMENT it and move it to the next line?
    # Or was it INTENDED to be a comment?
    # "MyVar" is used in the next lines: "if (MyVar = MyVar2)".
    # So it MUST be code.
    # It seems the conversion process or something pasted the code after the directive but didn't add a newline, and since there was a ; (maybe from Source comment?), it got commented out.
    
    # So we should look for any text after "#SingleInstance Force ;" that looks like code.
    # Or just move EVERYTHING after "#SingleInstance Force" to a new line?
    # If it starts with ";", we move it to a new line.
    # If it's just a comment, it's fine on a new line.
    # If it's code (commented out), it will still be commented out on the new line!
    # Wait, if I move "; MyVar := "joe"" to a new line, it becomes:
    # #SingleInstance Force
    # ; MyVar := "joe"
    # It is STILL a comment.
    # But the code needs it to be UNCOMMENTED.
    # So I need to remove the `;` if it looks like code?
    # That's dangerous.
    
    # Let's look at the previous fix.
    # #SingleInstance Force ; Source: ... .ah2 a := 1
    # Here "a := 1" was AFTER the .ah2 and space.
    # The ; started the comment "Source: ...".
    # So "a := 1" was part of the comment.
    # Moving it to a new line UNCOMMENTS it only if I remove the leading part of the comment?
    # No, I split the line.
    # Original: #SingleInstance Force ; Source... a := 1
    # My script did:
    # #SingleInstance Force ; Source...
    # a := 1
    # Wait, how did it split?
    # regex = re.compile(r'^(#SingleInstance Force\s+;\s+Source:.*\.ah2)\s+(.+)$')
    # Group 1: "#SingleInstance Force ; Source: ... .ah2"
    # Group 2: "a := 1"
    # So it kept the comment on the first line, and put the code on the second line.
    # This works because the code was AFTER the comment text.
    
    # Now consider: #SingleInstance Force ; MyVar := "joe"
    # Here, the code IS the comment.
    # If I split it, I get:
    # #SingleInstance Force ;
    # MyVar := "joe"
    # This would work!
    # But I need to find where the "code" starts.
    # In " ; MyVar := "joe"", the code starts at "MyVar".
    # But there is no marker like ".ah2".
    
    # Maybe I can assume that if there is a variable assignment or function call, it's code.
    # But that's hard to regex.
    
    # Let's look at the specific pattern in File_FileAppend_ex12.ahk.
    # #SingleInstance Force ; MyVar := "joe"
    # It seems the ";" was inserted, or it was there.
    # If I just split after "Force", I get:
    # #SingleInstance Force
    # ; MyVar := "joe"
    # Still a comment.
    # So I need to detect that "MyVar := "joe"" is code and uncomment it.
    # Or maybe the ";" was NOT intended to be there?
    # Or maybe it WAS intended to be a comment, but the code relies on it?
    # "if (MyVar = MyVar2)" implies MyVar must be defined.
    # So yes, it must be code.
    
    # I will look for patterns where the comment looks like an assignment or function call.
    regex = re.compile(r'^(#SingleInstance Force)\s+;\s+(.+)$')
    
    for root, dirs, files in os.walk(TARGET_DIR):
        for file in files:
            if file.endswith(".ahk"):
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        lines = f.readlines()
                    
                    new_lines = []
                    modified = False
                    
                    for line in lines:
                        # Check if line matches the pattern
                        match = regex.match(line.strip())
                        if match:
                            prefix = match.group(1) # #SingleInstance Force
                            content = match.group(2) # MyVar := "joe" OR Source: ... .ah2 a := 1
                            
                            # Check if content has the Source pattern
                            source_match = re.match(r'^(Source:.*\.ah2)\s+(.+)$', content)
                            if source_match:
                                # Case 1: Source comment followed by code
                                # #SingleInstance Force ; Source: ... .ah2 a := 1
                                # We want:
                                # #SingleInstance Force ; Source: ... .ah2
                                # a := 1
                                comment_part = source_match.group(1)
                                code_part = source_match.group(2)
                                new_lines.append(f"{prefix} ; {comment_part}\n")
                                new_lines.append(f"{code_part}\n")
                                modified = True
                            else:
                                # Case 2: Just code (or comment) after ;
                                # #SingleInstance Force ; MyVar := "joe"
                                # We want:
                                # #SingleInstance Force
                                # MyVar := "joe"
                                # BUT only if it looks like code?
                                # If it's "Source: ...", we leave it as comment.
                                if content.startswith("Source:"):
                                    new_lines.append(line)
                                else:
                                    # Assume it's code that was accidentally commented
                                    new_lines.append(f"{prefix}\n")
                                    new_lines.append(f"{content}\n")
                                    modified = True
                        else:
                            new_lines.append(line)
                    
                    if modified:
                        with open(file_path, 'w', encoding='utf-8') as f:
                            f.writelines(new_lines)
                        count += 1
                        # print(f"Fixed: {file}")
                        
                except Exception as e:
                    print(f"Error processing {file}: {e}")

    print(f"Total files updated: {count}")

if __name__ == "__main__":
    fix_concatenation()
