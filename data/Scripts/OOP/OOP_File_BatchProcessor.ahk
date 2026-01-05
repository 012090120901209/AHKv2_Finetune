#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP File Processing
class FileProcessor {
    __New(filePath) => (this.filePath := filePath, this.data := "")
    Process() => MsgBox("Processing: " . this.filePath)
}
FileProcessor("example.txt").Process()
