import os
import subprocess
import sys
import json

# Configuration
AHK_EXE = r"C:\Program Files\AutoHotkey\v2\AutoHotkey.exe"
TARGET_DIR = r"C:\Users\uphol\Documents\Design\Coding\ahk-finetune\data\raw_scripts\AHK_v2_Examples"
LOG_FILE = "validation_errors.json"

def validate_scripts():
    print(f"Scanning {TARGET_DIR}...")
    ahk_files = []
    for root, dirs, files in os.walk(TARGET_DIR):
        for file in files:
            if file.endswith(".ahk"):
                ahk_files.append(os.path.join(root, file))

    print(f"Found {len(ahk_files)} AHK files.")
    
    results = {
        "summary": {
            "total": len(ahk_files),
            "passed": 0,
            "failed": 0,
            "errors": 0
        },
        "failures": []
    }

    for i, file_path in enumerate(ahk_files):
        try:
            # Run AutoHotkey /validate /ErrorStdOut
            # Add timeout to prevent hanging
            # Add hidden window flags
            startupinfo = subprocess.STARTUPINFO()
            startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW
            CREATE_NO_WINDOW = 0x08000000

            result = subprocess.run(
                [AHK_EXE, "/validate", "/ErrorStdOut", file_path],
                capture_output=True,
                text=True,
                encoding='utf-8',
                errors='replace',
                timeout=5,
                startupinfo=startupinfo,
                creationflags=CREATE_NO_WINDOW
            )

            if result.returncode != 0 or result.stderr or result.stdout:
                error_msg = result.stderr.strip() or result.stdout.strip()
                # Filter out empty outputs if return code is 0 (sometimes happens)
                if result.returncode == 0 and not error_msg:
                    results["summary"]["passed"] += 1
                    continue
                
                print(f"FAIL: {os.path.basename(file_path)}")
                print(f"  {error_msg.splitlines()[0] if error_msg else 'Unknown error'}")
                results["summary"]["failed"] += 1
                results["failures"].append({
                    "file": file_path,
                    "error": error_msg,
                    "returncode": result.returncode
                })
            else:
                results["summary"]["passed"] += 1

        except subprocess.TimeoutExpired:
            print(f"TIMEOUT: {os.path.basename(file_path)}")
            results["summary"]["failed"] += 1
            results["failures"].append({
                "file": file_path,
                "error": "Validation timed out after 5 seconds",
                "returncode": -1
            })
        except Exception as e:
            print(f"ERROR: {os.path.basename(file_path)} - {str(e)}")
            results["summary"]["errors"] += 1
            results["failures"].append({
                "file": file_path,
                "error": str(e),
                "returncode": -2
            })
            
        if (i + 1) % 10 == 0:
            print(f"Processed {i + 1}/{len(ahk_files)} files...")
            # Save results to JSON incrementally
            with open(LOG_FILE, 'w', encoding='utf-8') as f:
                json.dump(results, f, indent=2)

    # Save results to JSON
    with open(LOG_FILE, 'w', encoding='utf-8') as f:
        json.dump(results, f, indent=2)
    
    print("-" * 40)
    print(f"Validation complete.")
    print(f"Total: {results['summary']['total']}")
    print(f"Passed: {results['summary']['passed']}")
    print(f"Failed: {results['summary']['failed']}")
    print(f"Errors: {results['summary']['errors']}")
    print(f"Results saved to {LOG_FILE}")

if __name__ == "__main__":
    if not os.path.exists(AHK_EXE):
        print(f"Error: AutoHotkey executable not found at {AHK_EXE}")
        sys.exit(1)
    
    validate_scripts()
