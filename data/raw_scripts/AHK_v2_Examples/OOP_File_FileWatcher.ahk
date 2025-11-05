#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; OOP File Processing
class FileProcessor {
    __New(filePath) => (this.filePath := filePath, this.data := "")
    Process() => MsgBox("Processing: " . this.filePath)
}
FileProcessor("example.txt").Process()
