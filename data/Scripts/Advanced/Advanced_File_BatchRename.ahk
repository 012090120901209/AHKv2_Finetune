#Requires AutoHotkey v2.0
#SingleInstance Force
; Advanced File Example: Batch File Renamer
; Demonstrates: File operations, pattern matching, preview, undo capability

renGui := Gui()
renGui.Title := "Batch File Renamer"

renGui.Add("Text", "x10 y10", "Source Folder:")
folderInput := renGui.Add("Edit", "x100 y7 w350 ReadOnly")
renGui.Add("Button", "x460 y6 w100", "Browse").OnEvent("Click", BrowseFolder)

renGui.Add("Text", "x10 y40", "File Pattern:")
patternInput := renGui.Add("Edit", "x100 y37 w150", "*.*")
renGui.Add("Button", "x260 y36 w100", "Load Files").OnEvent("Click", LoadFiles)

renGui.Add("GroupBox", "x10 y70 w550 h120", "Rename Options")
renGui.Add("Text", "x20 y95", "Find:")
findInput := renGui.Add("Edit", "x100 y92 w150")
renGui.Add("Text", "x20 y125", "Replace:")
replaceInput := renGui.Add("Edit", "x100 y122 w150")

renGui.Add("Text", "x20 y155", "Prefix:")
prefixInput := renGui.Add("Edit", "x100 y152 w150")
renGui.Add("Text", "x270 y155", "Suffix:")
suffixInput := renGui.Add("Edit", "x350 y152 w150")

renGui.Add("Checkbox", "x270 y95 vCaseSensitive", "Case Sensitive")
renGui.Add("Checkbox", "x270 y120 vRegex", "Use Regex")

LV := renGui.Add("ListView", "x10 y200 w550 h200", ["Original Name", "New Name"])

renGui.Add("Button", "x10 y410 w120", "Preview").OnEvent("Click", PreviewRename)
renGui.Add("Button", "x140 y410 w120", "Rename Files").OnEvent("Click", DoRename)
renGui.Add("Button", "x270 y410 w120", "Undo Last").OnEvent("Click", UndoRename)

statusBar := renGui.Add("StatusBar")

renGui.Show("w570 h460")

global currentFiles := []
global undoHistory := []

BrowseFolder(*) {
    selected := DirSelect(, 3, "Select folder")
    if (selected)
    folderInput.Value := selected
}

LoadFiles(*) {
    global currentFiles
    currentFiles := []
    LV.Delete()

    folder := folderInput.Value
    pattern := patternInput.Value

    if (!DirExist(folder))
    return

    Loop Files, folder "\" pattern, "F" {
        currentFiles.Push(Map("original", A_LoopFileName, "path", A_LoopFilePath))
        LV.Add(, A_LoopFileName, A_LoopFileName)
    }

    LV.ModifyCol()
    statusBar.SetText("  Loaded " currentFiles.Length " files")
}

PreviewRename(*) {
    find := findInput.Value
    replace := replaceInput.Value
    prefix := prefixInput.Value
    suffix := suffixInput.Value

    for i, file in currentFiles {
        newName := file["original"]

        ; Apply find/replace
        if (find != "")
        newName := StrReplace(newName, find, replace)

        ; Add prefix/suffix
        SplitPath(newName, &name, , &ext)
        newName := prefix name suffix (ext ? "." ext : "")

        LV.Modify(i, , file["original"], newName)
    }

    LV.ModifyCol()
}

DoRename(*) {
    renamed := 0
    batch := []

    Loop LV.GetCount() {
        original := LV.GetText(A_Index, 1)
        newName := LV.GetText(A_Index, 2)

        if (original != newName) {
            for file in currentFiles {
                if (file["original"] = original) {
                    oldPath := file["path"]
                    SplitPath(oldPath, , &dir)
                    newPath := dir "\" newName

                    try {
                        FileMove(oldPath, newPath)
                        batch.Push(Map("old", oldPath, "new", newPath))
                        renamed++
                    }
                    break
                }
            }
        }
    }

    if (batch.Length > 0)
    undoHistory.Push(batch)

    MsgBox("Renamed " renamed " files", "Complete")
    LoadFiles()
}

UndoRename(*) {
    if (undoHistory.Length = 0) {
        MsgBox("Nothing to undo!", "Info")
        return
    }

    batch := undoHistory.Pop()

    for op in batch {
        try FileMove(op["new"], op["old"])
    }

    MsgBox("Undone!", "Success")
    LoadFiles()
}
