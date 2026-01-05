import os
import sys
import json
import time
import subprocess
import threading
import tkinter as tk
from tkinter.scrolledtext import ScrolledText

# --------- CONFIGURE THESE ---------
AHK_EXE = r"C:\Program Files\AutoHotkey\v2\AutoHotkey.exe"
TARGET_DIR = r"C:\Users\uphol\Documents\Design\Coding\ahk-finetune\data\raw_scripts\AHK_v2_Examples"
LOG_FILE = "validation_errors.json"
# -----------------------------------


class ValidatorGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("AHK Batch Validator")
        self.root.geometry("800x500")
        self.root.attributes("-topmost", True)

        # Control buttons
        btn_frame = tk.Frame(root)
        btn_frame.pack(fill="x", pady=5)

        self.start_btn = tk.Button(btn_frame, text="Start", width=10, command=self.start_validation)
        self.start_btn.pack(side="left", padx=5)

        self.pause_btn = tk.Button(btn_frame, text="Pause", width=10, command=self.toggle_pause, state="disabled")
        self.pause_btn.pack(side="left", padx=5)

        self.stop_btn = tk.Button(btn_frame, text="Stop", width=10, command=self.stop_validation, state="disabled")
        self.stop_btn.pack(side="left", padx=5)

        self.quit_btn = tk.Button(btn_frame, text="Quit", width=10, command=self.on_quit)
        self.quit_btn.pack(side="right", padx=5)

        # Status label
        self.status_var = tk.StringVar(value="Idle")
        status_label = tk.Label(root, textvariable=self.status_var, anchor="w")
        status_label.pack(fill="x")

        # Log window
        self.log_widget = ScrolledText(root, state="disabled", wrap="word")
        self.log_widget.pack(fill="both", expand=True, padx=5, pady=5)

        # State flags
        self.thread = None
        self.stop_event = threading.Event()
        self.paused = False
        self.lock = threading.Lock()

        self.results = None

        self.root.protocol("WM_DELETE_WINDOW", self.on_quit)

    # ---------- GUI helpers ----------

    def log(self, msg):
        """Thread-safe log to the text box."""
        def _append():
            self.log_widget.configure(state="normal")
            self.log_widget.insert("end", msg + "\n")
            self.log_widget.see("end")
            self.log_widget.configure(state="disabled")
        self.root.after(0, _append)

    def set_status(self, text):
        self.root.after(0, lambda: self.status_var.set(text))

    def set_buttons_running(self, running: bool):
        def _set():
            if running:
                self.start_btn.config(state="disabled")
                self.pause_btn.config(state="normal")
                self.stop_btn.config(state="normal")
            else:
                self.start_btn.config(state="normal")
                self.pause_btn.config(state="disabled", text="Pause")
                self.stop_btn.config(state="disabled")
        self.root.after(0, _set)

    # ---------- Control actions ----------

    def start_validation(self):
        if self.thread and self.thread.is_alive():
            return  # already running

        if not os.path.exists(AHK_EXE):
            self.log(f"Error: AutoHotkey executable not found at {AHK_EXE}")
            self.set_status("Error: AHK exe not found")
            return

        self.stop_event.clear()
        self.paused = False
        self.set_buttons_running(True)
        self.set_status("Running...")
        self.log("Starting validation...")

        self.thread = threading.Thread(target=self.run_validation_loop, daemon=True)
        self.thread.start()

    def toggle_pause(self):
        with self.lock:
            self.paused = not self.paused
            if self.paused:
                self.pause_btn.config(text="Resume")
                self.set_status("Paused")
                self.log("[Paused]")
            else:
                self.pause_btn.config(text="Pause")
                self.set_status("Running...")
                self.log("[Resumed]")

    def stop_validation(self):
        self.stop_event.set()
        self.set_status("Stopping after current file...")
        self.log("[Stop requested]")

    def on_quit(self):
        self.stop_event.set()
        self.root.destroy()

    # ---------- Validation logic ----------

    def run_validation_loop(self):
        """Background thread target."""
        ahk_files = []
        for root_dir, dirs, files in os.walk(TARGET_DIR):
            for file in files:
                if file.endswith(".ahk"):
                    ahk_files.append(os.path.join(root_dir, file))

        total = len(ahk_files)
        self.log(f"Scanning {TARGET_DIR}...")
        self.log(f"Found {total} AHK files.")

        results = {
            "summary": {
                "total": total,
                "passed": 0,
                "failed": 0,
                "errors": 0,
            },
            "failures": [],
        }

        for i, file_path in enumerate(ahk_files):
            if self.stop_event.is_set():
                self.log("Stop flag set. Exiting loop.")
                break

            # Pause control between files
            while True:
                if self.stop_event.is_set():
                    break
                with self.lock:
                    paused_local = self.paused
                if not paused_local:
                    break
                time.sleep(0.2)
            if self.stop_event.is_set():
                break

            filename = os.path.basename(file_path)
            self.set_status(f"Validating {i + 1}/{total}: {filename}")

            try:
                # Run AutoHotkey /validate /ErrorStdOut
                # Added hidden window flags as per user request for consistency
                startupinfo = subprocess.STARTUPINFO()
                startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW
                CREATE_NO_WINDOW = 0x08000000
                
                result = subprocess.run(
                    [AHK_EXE, "/validate", "/ErrorStdOut", file_path],
                    capture_output=True,
                    text=True,
                    encoding="utf-8",
                    errors="replace",
                    timeout=5,
                    startupinfo=startupinfo,
                    creationflags=CREATE_NO_WINDOW,
                )

                stderr = (result.stderr or "").strip()
                stdout = (result.stdout or "").strip()
                error_msg = stderr or stdout

                if result.returncode != 0 or error_msg:
                    if result.returncode == 0 and not error_msg:
                        results["summary"]["passed"] += 1
                    else:
                        self.log(f"FAIL: {filename}")
                        first_line = error_msg.splitlines()[0] if error_msg else "Unknown error"
                        self.log(f"  {first_line}")
                        results["summary"]["failed"] += 1
                        results["failures"].append(
                            {
                                "file": file_path,
                                "error": error_msg,
                                "returncode": result.returncode,
                            }
                        )
                else:
                    results["summary"]["passed"] += 1

            except subprocess.TimeoutExpired:
                self.log(f"TIMEOUT: {filename}")
                results["summary"]["failed"] += 1
                results["failures"].append(
                    {
                        "file": file_path,
                        "error": "Validation timed out after 5 seconds",
                        "returncode": -1,
                    }
                )
            except Exception as e:
                self.log(f"ERROR: {filename} - {str(e)}")
                results["summary"]["errors"] += 1
                results["failures"].append(
                    {
                        "file": file_path,
                        "error": str(e),
                        "returncode": -2,
                    }
                )

            if (i + 1) % 10 == 0:
                self.log(f"Processed {i + 1}/{total} files...")
                self.save_results(results)

            if self.stop_event.is_set():
                break

        self.save_results(results)
        self.log("-" * 40)
        self.log("Validation complete.")
        self.log(f"Total: {results['summary']['total']}")
        self.log(f"Passed: {results['summary']['passed']}")
        self.log(f"Failed: {results['summary']['failed']}")
        self.log(f"Errors: {results['summary']['errors']}")
        self.log(f"Results saved to {LOG_FILE}")

        self.set_status("Idle")
        self.set_buttons_running(False)

    def save_results(self, results):
        try:
            with open(LOG_FILE, "w", encoding="utf-8") as f:
                json.dump(results, f, indent=2)
        except Exception as e:
            self.log(f"Error writing log file: {e}")


if __name__ == "__main__":
    root = tk.Tk()
    app = ValidatorGUI(root)
    root.mainloop()
