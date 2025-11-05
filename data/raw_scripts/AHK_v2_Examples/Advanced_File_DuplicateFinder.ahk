#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; Duplicate File Finder using file size comparison
dupGui := Gui()
dupGui.Title := "Duplicate File Finder"
dupGui.Add("Text", "x10 y10", "Scan Folder:")
folderInput := dupGui.Add("Edit", "x100 y7 w300 ReadOnly")
dupGui.Add("Button", "x410 y6 w80", "Browse").OnEvent("Click", BrowseDir)
dupGui.Add("Button", "x500 y6 w80", "Scan").OnEvent("Click", ScanDuplicates)

LV := dupGui.Add("ListView", "x10 y40 w570 h300", ["File", "Size", "Duplicate Of"])
dupGui.Add("Button", "x10 y350 w150", "Delete Selected").OnEvent("Click", DeleteDups)
statusBar := dupGui.Add("StatusBar")
dupGui.Show("w590 h395")

BrowseDir(*) {
    selected := DirSelect(, 3, "Select folder to scan")
    if (selected)
        folderInput.Value := selected
}

ScanDuplicates(*) {
    folder := folderInput.Value
    if (!DirExist(folder))
        return
    
    LV.Delete()
    sizeMap := Map()
    
    Loop Files, folder "\*.*", "FR" {
        size := A_LoopFileSize
        name := A_LoopFileName
        
        if (sizeMap.Has(size)) {
            LV.Add(, name, size, sizeMap[size])
        } else {
            sizeMap[size] := name
        }
    }
    
    LV.ModifyCol()
    statusBar.SetText("  Found " LV.GetCount() " potential duplicates")
}

DeleteDups(*) {
    row := LV.GetNext()
    if (row) {
        file := LV.GetText(row, 1)
        result := MsgBox("Delete " file "?", "Confirm", "YesNo")
        if (result = "Yes") {
            try FileDelete(folderInput.Value "\" file)
            LV.Delete(row)
        }
    }
}
