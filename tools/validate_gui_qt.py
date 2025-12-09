import sys
import os
import json
import subprocess
import time
from PySide6.QtWidgets import (QApplication, QMainWindow, QWidget, QVBoxLayout, 
                               QHBoxLayout, QPushButton, QTextEdit, QLabel, 
                               QProgressBar, QStyleFactory)
from PySide6.QtCore import QThread, Signal, Slot, Qt, QObject, QMutex, QMutexLocker
from PySide6.QtGui import QPalette, QColor, QFont
import qtawesome as qta

# --------- CONFIGURE THESE ---------
AHK_EXE = r"C:\Program Files\AutoHotkey\v2\AutoHotkey.exe"
TARGET_DIR = r"C:\Users\uphol\Documents\Design\Coding\ahk-finetune\data\raw_scripts\AHK_v2_Examples"
LOG_FILE = "validation_errors.json"
# -----------------------------------

class ValidationWorker(QObject):
    log_signal = Signal(str)
    status_signal = Signal(str)
    progress_signal = Signal(int, int)
    finished_signal = Signal()
    
    def __init__(self):
        super().__init__()
        self._paused = False
        self._stopped = False
        self._mutex = QMutex()

    def clean_path(self, path):
        # Remove the project root prefix for cleaner logs
        prefix = r"C:\Users\uphol\Documents\Design\Coding\ahk-finetune"
        if path.startswith(prefix):
            return path[len(prefix):].lstrip(os.sep)
        return path

    @Slot()
    def run(self):
        if not os.path.exists(AHK_EXE):
            self.log_signal.emit(f"Error: AutoHotkey executable not found at {AHK_EXE}")
            self.finished_signal.emit()
            return

        ahk_files = []
        for root_dir, dirs, files in os.walk(TARGET_DIR):
            for file in files:
                if file.endswith(".ahk"):
                    ahk_files.append(os.path.join(root_dir, file))

        total = len(ahk_files)
        self.log_signal.emit(f"Scanning {self.clean_path(TARGET_DIR)}...")
        self.log_signal.emit(f"Found {total} AHK files.")

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
            # Check stop
            if self._stopped:
                break

            # Check pause
            while self._paused:
                if self._stopped:
                    break
                time.sleep(0.1)
            
            if self._stopped:
                break

            filename = os.path.basename(file_path)
            self.status_signal.emit(f"Validating {i + 1}/{total}: {filename}")
            self.progress_signal.emit(i + 1, total)

            try:
                # Hidden window flags
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
                        self.log_signal.emit(f"FAIL: {filename}")
                        first_line = error_msg.splitlines()[0] if error_msg else "Unknown error"
                        # Clean path in error message if present
                        clean_error = first_line.replace(r"C:\Users\uphol\Documents\Design\Coding\ahk-finetune", "")
                        self.log_signal.emit(f"  {clean_error}")
                        results["summary"]["failed"] += 1
                        results["failures"].append({
                            "file": file_path,
                            "error": error_msg,
                            "returncode": result.returncode,
                        })
                else:
                    results["summary"]["passed"] += 1

            except subprocess.TimeoutExpired:
                self.log_signal.emit(f"TIMEOUT: {filename}")
                results["summary"]["failed"] += 1
                results["failures"].append({
                    "file": file_path,
                    "error": "Validation timed out after 5 seconds",
                    "returncode": -1,
                })
            except Exception as e:
                self.log_signal.emit(f"ERROR: {filename} - {str(e)}")
                results["summary"]["errors"] += 1
                results["failures"].append({
                    "file": file_path,
                    "error": str(e),
                    "returncode": -2,
                })

            if (i + 1) % 10 == 0:
                self.save_results(results)

        self.save_results(results)
        self.log_signal.emit("-" * 40)
        self.log_signal.emit("Validation complete.")
        self.log_signal.emit(f"Total: {results['summary']['total']}")
        self.log_signal.emit(f"Passed: {results['summary']['passed']}")
        self.log_signal.emit(f"Failed: {results['summary']['failed']}")
        self.log_signal.emit(f"Errors: {results['summary']['errors']}")
        self.log_signal.emit(f"Results saved to {LOG_FILE}")
        
        self.finished_signal.emit()

    def save_results(self, results):
        try:
            with open(LOG_FILE, "w", encoding="utf-8") as f:
                json.dump(results, f, indent=2)
        except Exception as e:
            self.log_signal.emit(f"Error writing log file: {e}")

    def stop(self):
        self._stopped = True

    def pause(self):
        self._paused = True

    def resume(self):
        self._paused = False

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("AHK Validator Pro")
        self.resize(900, 600)
        
        # Setup dark theme
        self.setup_dark_theme()

        # Main layout
        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        layout = QVBoxLayout(central_widget)
        layout.setSpacing(10)
        layout.setContentsMargins(20, 20, 20, 20)

        # Header
        header_layout = QHBoxLayout()
        title_label = QLabel("AHK v2 Script Validator")
        title_label.setFont(QFont("Segoe UI", 18, QFont.Bold))
        title_label.setStyleSheet("color: #ffffff;")
        header_layout.addWidget(title_label)
        header_layout.addStretch()
        layout.addLayout(header_layout)

        # Status Bar area
        self.status_label = QLabel("Ready to start")
        self.status_label.setFont(QFont("Segoe UI", 11))
        self.status_label.setStyleSheet("color: #aaaaaa; margin-bottom: 5px;")
        layout.addWidget(self.status_label)

        # Progress Bar
        self.progress_bar = QProgressBar()
        self.progress_bar.setStyleSheet("""
            QProgressBar {
                border: none;
                background-color: #2d2d2d;
                height: 8px;
                border-radius: 4px;
            }
            QProgressBar::chunk {
                background-color: #3498db;
                border-radius: 4px;
            }
        """)
        self.progress_bar.setTextVisible(False)
        layout.addWidget(self.progress_bar)

        # Log Area
        self.log_text = QTextEdit()
        self.log_text.setReadOnly(True)
        self.log_text.setFont(QFont("Consolas", 10))
        self.log_text.setStyleSheet("""
            QTextEdit {
                background-color: #1e1e1e;
                color: #d4d4d4;
                border: 1px solid #333333;
                border-radius: 5px;
                padding: 5px;
            }
        """)
        layout.addWidget(self.log_text)

        # Controls
        controls_layout = QHBoxLayout()
        controls_layout.setSpacing(15)
        
        # Buttons
        self.start_btn = self.create_button("Start Validation", "fa5s.play", "#2ecc71")
        self.start_btn.clicked.connect(self.start_validation)
        
        self.pause_btn = self.create_button("Pause", "fa5s.pause", "#f1c40f")
        self.pause_btn.clicked.connect(self.toggle_pause)
        self.pause_btn.setEnabled(False)
        
        self.stop_btn = self.create_button("Stop", "fa5s.stop", "#e74c3c")
        self.stop_btn.clicked.connect(self.stop_validation)
        self.stop_btn.setEnabled(False)

        controls_layout.addWidget(self.start_btn)
        controls_layout.addWidget(self.pause_btn)
        controls_layout.addWidget(self.stop_btn)
        controls_layout.addStretch()
        
        layout.addLayout(controls_layout)

        # Threading
        self.thread = None
        self.worker = None
        self.is_paused = False

    def setup_dark_theme(self):
        app = QApplication.instance()
        app.setStyle("Fusion")
        
        palette = QPalette()
        palette.setColor(QPalette.Window, QColor(30, 30, 30))
        palette.setColor(QPalette.WindowText, Qt.white)
        palette.setColor(QPalette.Base, QColor(25, 25, 25))
        palette.setColor(QPalette.AlternateBase, QColor(35, 35, 35))
        palette.setColor(QPalette.ToolTipBase, Qt.white)
        palette.setColor(QPalette.ToolTipText, Qt.white)
        palette.setColor(QPalette.Text, Qt.white)
        palette.setColor(QPalette.Button, QColor(45, 45, 45))
        palette.setColor(QPalette.ButtonText, Qt.white)
        palette.setColor(QPalette.BrightText, Qt.red)
        palette.setColor(QPalette.Link, QColor(42, 130, 218))
        palette.setColor(QPalette.Highlight, QColor(42, 130, 218))
        palette.setColor(QPalette.HighlightedText, Qt.black)
        
        app.setPalette(palette)

    def create_button(self, text, icon_name, color):
        btn = QPushButton(text)
        btn.setIcon(qta.icon(icon_name, color=color))
        btn.setFont(QFont("Segoe UI", 10, QFont.Bold))
        btn.setCursor(Qt.PointingHandCursor)
        btn.setStyleSheet(f"""
            QPushButton {{
                background-color: #333333;
                border: 1px solid #444444;
                border-radius: 5px;
                padding: 8px 15px;
                color: white;
                text-align: left;
            }}
            QPushButton:hover {{
                background-color: #404040;
                border-color: {color};
            }}
            QPushButton:pressed {{
                background-color: #252525;
            }}
            QPushButton:disabled {{
                background-color: #252525;
                color: #555555;
                border-color: #333333;
            }}
        """)
        return btn

    def start_validation(self):
        self.start_btn.setEnabled(False)
        self.pause_btn.setEnabled(True)
        self.stop_btn.setEnabled(True)
        self.log_text.clear()
        self.progress_bar.setValue(0)
        
        self.thread = QThread()
        self.worker = ValidationWorker()
        self.worker.moveToThread(self.thread)
        
        self.thread.started.connect(self.worker.run)
        self.worker.finished_signal.connect(self.thread.quit)
        self.worker.finished_signal.connect(self.worker.deleteLater)
        self.thread.finished.connect(self.thread.deleteLater)
        self.thread.finished.connect(self.on_finished)
        
        self.worker.log_signal.connect(self.append_log)
        self.worker.status_signal.connect(self.update_status)
        self.worker.progress_signal.connect(self.update_progress)
        
        self.thread.start()

    def toggle_pause(self):
        if self.is_paused:
            self.worker.resume()
            self.pause_btn.setText("Pause")
            self.pause_btn.setIcon(qta.icon("fa5s.pause", color="#f1c40f"))
            self.status_label.setText("Resuming...")
            self.is_paused = False
        else:
            self.worker.pause()
            self.pause_btn.setText("Resume")
            self.pause_btn.setIcon(qta.icon("fa5s.play", color="#f1c40f"))
            self.status_label.setText("Paused")
            self.is_paused = True

    def stop_validation(self):
        if self.worker:
            self.worker.stop()
            self.status_label.setText("Stopping...")
            self.stop_btn.setEnabled(False)
            self.pause_btn.setEnabled(False)

    def on_finished(self):
        self.start_btn.setEnabled(True)
        self.pause_btn.setEnabled(False)
        self.stop_btn.setEnabled(False)
        self.status_label.setText("Validation Finished")
        self.progress_bar.setValue(100)
        self.worker = None
        self.is_paused = False
        self.pause_btn.setText("Pause")
        self.pause_btn.setIcon(qta.icon("fa5s.pause", color="#f1c40f"))

    @Slot(str)
    def append_log(self, text):
        self.log_text.append(text)

    @Slot(str)
    def update_status(self, text):
        self.status_label.setText(text)

    @Slot(int, int)
    def update_progress(self, current, total):
        self.progress_bar.setMaximum(total)
        self.progress_bar.setValue(current)

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec())
