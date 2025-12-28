#Requires AutoHotkey v2.0
#SingleInstance Force
; Advanced GUI Example: Progress Bar with Multi-threaded Simulation
; Demonstrates: Progress bar, timer, dynamic text updates, cancel functionality

Persistent

myGui := Gui()
myGui.Title := "File Processing Simulator"

myGui.Add("Text", "x10 y10", "Simulating file processing with progress tracking...")
statusText := myGui.Add("Text", "x10 y35 w380", "Ready to start")
progress := myGui.Add("Progress", "x10 y60 w380 h30 -Smooth")
fileText := myGui.Add("Text", "x10 y100 w380", "Files: 0/100")
speedText := myGui.Add("Text", "x10 y125 w380", "Speed: 0 files/sec")

startBtn := myGui.Add("Button", "x10 y160 w120", "Start Processing").OnEvent("Click", StartProcess)
cancelBtn := myGui.Add("Button", "x140 y160 w120", "Cancel").OnEvent("Click", CancelProcess)
cancelBtn.Enabled := false

myGui.Show("w400 h200")

global isProcessing := false
global currentFile := 0
global totalFiles := 100
global startTime := 0

StartProcess(*) {
    global isProcessing, currentFile, startTime, startBtn, cancelBtn

    isProcessing := true
    currentFile := 0
    startTime := A_TickCount

    startBtn.Enabled := false
    cancelBtn.Enabled := true

    statusText.Value := "Processing files..."
    SetTimer(UpdateProgress, 50)
}

CancelProcess(*) {
    global isProcessing, startBtn, cancelBtn

    isProcessing := false
    SetTimer(UpdateProgress, 0)

    statusText.Value := "Processing cancelled"
    startBtn.Enabled := true
    cancelBtn.Enabled := false
}

UpdateProgress() {
    global isProcessing, currentFile, totalFiles, startTime

    if (!isProcessing)
        return

    currentFile += Random(1, 3)

    if (currentFile >= totalFiles) {
        currentFile := totalFiles
        isProcessing := false
        SetTimer(UpdateProgress, 0)

        statusText.Value := "Processing complete!"
        progress.Value := 100
        fileText.Value := "Files: " totalFiles "/" totalFiles
        startBtn.Enabled := true
        cancelBtn.Enabled := false

        elapsed := (A_TickCount - startTime) / 1000
        MsgBox("Processed " totalFiles " files in " Round(elapsed, 2) " seconds", "Complete")
        return
    }

    ; Update progress bar
    percent := Round((currentFile / totalFiles) * 100)
    progress.Value := percent

    ; Update file count
    fileText.Value := "Files: " currentFile "/" totalFiles

    ; Calculate speed
    elapsed := (A_TickCount - startTime) / 1000
    speed := elapsed > 0 ? Round(currentFile / elapsed, 2) : 0
    speedText.Value := "Speed: " speed " files/sec"

    ; Update status with current "file"
    statusText.Value := "Processing: file_" currentFile ".dat"
}
