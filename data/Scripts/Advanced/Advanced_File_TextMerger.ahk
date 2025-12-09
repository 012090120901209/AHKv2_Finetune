#Requires AutoHotkey v2.0
#SingleInstance Force

mergeGui := Gui()
mergeGui.Title := "Text File Merger"
LV := mergeGui.Add("ListView", "x10 y10 w400 h250", ["File", "Lines"])
mergeGui.Add("Button", "x10 y270 w80", "Add").OnEvent("Click", AddFile)
mergeGui.Add("Button", "x100 y270 w80", "Remove").OnEvent("Click", RemoveFile)
mergeGui.Add("Button", "x190 y270 w110", "Merge Files").OnEvent("Click", MergeFiles)
mergeGui.Show("w420 h310")

global files := []

AddFile(*) {
    selected := FileSelect("M3", , "Select Files", "Text Files (*.txt)")
    if (!selected)
    return
    for file in selected {
        if (A_Index = 1)
        continue
        lines := StrSplit(FileRead(file), "`n").Length
        LV.Add(, file, lines)
        files.Push(file)
    }
    LV.ModifyCol()
}

RemoveFile(*) {
    row := LV.GetNext()
    if (row) {
        LV.Delete(row)
        files.RemoveAt(row)
    }
}

MergeFiles(*) {
    if (files.Length = 0)
    return MsgBox("Add files first!", "Error")

    output := ""
    for file in files {
        output .= FileRead(file) "`n`n"
    }

    filename := "merged_" FormatTime(, "yyyyMMdd_HHmmss") ".txt"
    FileAppend(output, filename)
    MsgBox("Merged into " filename, "Success")
}
