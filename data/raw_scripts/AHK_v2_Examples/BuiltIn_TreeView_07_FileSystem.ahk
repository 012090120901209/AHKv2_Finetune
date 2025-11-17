#Requires AutoHotkey v2.0
/**
 * BuiltIn_TreeView_07_FileSystem.ahk
 *
 * DESCRIPTION:
 * Demonstrates building file system browsers and explorers using TreeView,
 * including directory traversal, file filtering, and real-time updates.
 *
 * FEATURES:
 * - Browsing local file system
 * - Lazy loading of directory contents
 * - File and folder filtering
 * - Drive enumeration
 * - Real-time file system monitoring
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/TreeView.htm
 * https://www.autohotkey.com/docs/v2/lib/LoopFiles.htm
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - File system loops
 * - Directory operations
 * - Dynamic tree population
 * - Event-based expansion
 *
 * LEARNING POINTS:
 * 1. Use Loop Files to enumerate directories
 * 2. Implement lazy loading for performance
 * 3. Handle file system errors gracefully
 * 4. Use expand event for on-demand loading
 * 5. Filter files by extension or pattern
 */

;=============================================================================
; EXAMPLE 1: Simple Directory Browser
;=============================================================================
; Basic file system browser with folders and files

Example1_SimpleBrowser() {
    myGui := Gui("+Resize", "Example 1: Simple Directory Browser")
    
    ; Create TreeView with icons
    ImageListID := IL_Create(10)
    FolderIcon := IL_Add(ImageListID, "shell32.dll", 4)
    FileIcon := IL_Add(ImageListID, "shell32.dll", 71)
    
    TV := myGui.Add("TreeView", "w600 h450 ImageList" . ImageListID)
    
    ; Get user profile directory
    userProfile := EnvGet("USERPROFILE")
    
    ; Add root folder
    Root := TV.Add(userProfile, 0, "Icon" . FolderIcon)
    
    ; Add immediate subdirectories and files
    try {
        ; Add folders first
        Loop Files, userProfile . "\*.*", "D" {
            if (A_LoopFileAttrib ~= "H")  ; Skip hidden
                continue
            TV.Add(A_LoopFileName, Root, "Icon" . FolderIcon)
        }
        
        ; Add files
        Loop Files, userProfile . "\*.*", "F" {
            if (A_LoopFileAttrib ~= "H")  ; Skip hidden
                continue
            TV.Add(A_LoopFileName, Root, "Icon" . FileIcon)
        }
    }
    
    TV.Modify(Root, "Expand")
    
    ; Info display
    infoText := myGui.Add("Edit", "xm y+10 w600 h100 ReadOnly")
    
    ; Show file info on selection
    TV.OnEvent("ItemSelect", ShowInfo)
    
    ShowInfo(*) {
        if (selected := TV.GetSelection()) {
            itemText := TV.GetText(selected)
            parent := TV.GetParent(selected)
            
            info := "Selected: " . itemText . "`n"
            
            if (parent) {
                parentText := TV.GetText(parent)
                fullPath := parentText . "\" . itemText
                
                if (FileExist(fullPath)) {
                    info .= "Path: " . fullPath . "`n"
                    
                    try {
                        attribs := FileGetAttrib(fullPath)
                        size := FileGetSize(fullPath)
                        time := FileGetTime(fullPath)
                        
                        info .= "Attributes: " . attribs . "`n"
                        info .= "Size: " . FormatBytes(size) . "`n"
                        info .= "Modified: " . FormatTime(time) . "`n"
                    }
                }
            }
            
            infoText.Value := info
        }
    }
    
    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => (IL_Destroy(ImageListID), myGui.Destroy()))
    
    myGui.OnEvent("Close", (*) => (IL_Destroy(ImageListID), myGui.Destroy()))
    myGui.Show()
}

; Format bytes to human readable
FormatBytes(bytes) {
    if (bytes < 1024)
        return bytes . " B"
    if (bytes < 1048576)
        return Round(bytes / 1024, 2) . " KB"
    if (bytes < 1073741824)
        return Round(bytes / 1048576, 2) . " MB"
    return Round(bytes / 1073741824, 2) . " GB"
}

;=============================================================================
; EXAMPLE 2: Lazy Loading File Browser
;=============================================================================
; Efficient browser that loads directories on demand

Example2_LazyLoading() {
    myGui := Gui("+Resize", "Example 2: Lazy Loading Browser")
    
    ; Create TreeView
    ImageListID := IL_Create(10)
    FolderIcon := IL_Add(ImageListID, "shell32.dll", 4)
    OpenFolderIcon := IL_Add(ImageListID, "shell32.dll", 5)
    FileIcon := IL_Add(ImageListID, "shell32.dll", 71)
    
    TV := myGui.Add("TreeView", "w600 h450 ImageList" . ImageListID)
    
    ; Track which nodes have been loaded
    loadedNodes := Map()
    
    ; Add drives as root nodes
    drives := GetDrives()
    for drive in drives {
        driveNode := TV.Add(drive, 0, "Icon" . FolderIcon)
        
        ; Add dummy child to show expand icon
        TV.Add("Loading...", driveNode)
    }
    
    ; Handle expansion - load on demand
    TV.OnEvent("ItemExpand", OnExpand)
    
    OnExpand(GuiCtrl, ItemID) {
        ; Skip if already loaded
        if (loadedNodes.Has(ItemID))
            return
        
        loadedNodes[ItemID] := true
        
        ; Get full path
        path := GetItemPath(TV, ItemID)
        
        ; Remove dummy child
        firstChild := TV.GetChild(ItemID)
        if (firstChild && TV.GetText(firstChild) = "Loading...")
            TV.Delete(firstChild)
        
        ; Load directory contents
        try {
            ; Add subdirectories
            Loop Files, path . "\*", "D" {
                if (A_LoopFileAttrib ~= "H|S")  ; Skip hidden and system
                    continue
                
                folderNode := TV.Add(A_LoopFileName, ItemID, "Icon" . FolderIcon)
                
                ; Check if folder has subdirectories
                hasSubdirs := false
                Loop Files, A_LoopFilePath . "\*", "D" {
                    hasSubdirs := true
                    break
                }
                
                ; Add dummy if has subdirectories
                if (hasSubdirs)
                    TV.Add("Loading...", folderNode)
            }
            
            ; Add files (limit to first 100 for performance)
            count := 0
            Loop Files, path . "\*", "F" {
                if (A_LoopFileAttrib ~= "H|S")
                    continue
                
                TV.Add(A_LoopFileName, ItemID, "Icon" . FileIcon)
                
                if (++count >= 100)
                    break
            }
        }
        catch as err {
            TV.Add("Error: Access Denied", ItemID)
        }
        
        ; Change icon to open folder
        TV.Modify(ItemID, "Icon" . OpenFolderIcon)
    }
    
    ; Get full path of item
    GetItemPath(TV, ItemID) {
        path := TV.GetText(ItemID)
        parent := TV.GetParent(ItemID)
        
        while (parent) {
            parentText := TV.GetText(parent)
            if (parentText ~= "^[A-Z]:\\?$")  ; Drive letter
                path := parentText . path
            else
                path := parentText . "\" . path
            parent := TV.GetParent(parent)
        }
        
        return path
    }
    
    ; Get available drives
    GetDrives() {
        drives := []
        Loop 26 {
            drive := Chr(64 + A_Index) . ":\"
            if (DriveType := DriveGetType(drive))
                drives.Push(drive)
        }
        return drives
    }
    
    ; Status
    statusText := myGui.Add("Text", "xm y+10 w600", "Expand folders to load contents")
    
    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => (IL_Destroy(ImageListID), myGui.Destroy()))
    
    myGui.OnEvent("Close", (*) => (IL_Destroy(ImageListID), myGui.Destroy()))
    myGui.Show()
}

;=============================================================================
; EXAMPLE 3: Filtered File Browser
;=============================================================================
; Browser with file type filtering

Example3_FilteredBrowser() {
    myGui := Gui("+Resize", "Example 3: Filtered File Browser")
    
    ; Create TreeView
    ImageListID := IL_Create(10)
    FolderIcon := IL_Add(ImageListID, "shell32.dll", 4)
    FileIcon := IL_Add(ImageListID, "shell32.dll", 71)
    
    TV := myGui.Add("TreeView", "w600 h400 ImageList" . ImageListID)
    
    ; Filter controls
    myGui.Add("Text", "xm y+10", "File Filter:")
    filterInput := myGui.Add("Edit", "x+10 yp-3 w150", "*.ahk")
    
    browseBtn := myGui.Add("Button", "x+10 yp-0 w100", "Browse Folder")
    browseBtn.OnEvent("Click", BrowseFolder)
    
    refreshBtn := myGui.Add("Button", "x+10 yp w100", "Refresh")
    refreshBtn.OnEvent("Click", RefreshTree)
    
    ; Current path
    currentPath := A_ScriptDir
    
    BrowseFolder(*) {
        selectedFolder := DirSelect("*" . currentPath, 3, "Select a folder to browse")
        if (selectedFolder) {
            currentPath := selectedFolder
            LoadDirectory(currentPath)
        }
    }
    
    RefreshTree(*) {
        LoadDirectory(currentPath)
    }
    
    LoadDirectory(path) {
        TV.Delete()  ; Clear tree
        
        filter := filterInput.Value
        if (!filter)
            filter := "*.*"
        
        Root := TV.Add(path, 0, "Icon" . FolderIcon)
        
        try {
            ; Add matching files
            Loop Files, path . "\" . filter, "F" {
                if (A_LoopFileAttrib ~= "H")
                    continue
                TV.Add(A_LoopFileName . " (" . FormatBytes(A_LoopFileSize) . ")", Root, "Icon" . FileIcon)
            }
            
            ; Add subdirectories
            Loop Files, path . "\*", "D" {
                if (A_LoopFileAttrib ~= "H")
                    continue
                
                folderNode := TV.Add(A_LoopFileName, Root, "Icon" . FolderIcon)
                
                ; Add files in subfolder
                Loop Files, A_LoopFilePath . "\" . filter, "F" {
                    if (A_LoopFileAttrib ~= "H")
                        continue
                    TV.Add(A_LoopFileName . " (" . FormatBytes(A_LoopFileSize) . ")", folderNode, "Icon" . FileIcon)
                }
            }
        }
        
        TV.Modify(Root, "Expand")
        UpdateStatus()
    }
    
    ; Status
    statusText := myGui.Add("Text", "xm y+10 w600", "")
    
    UpdateStatus() {
        fileCount := TV.GetCount()
        statusText.Value := "Showing: " . currentPath . " | Files: " . fileCount . " | Filter: " . filterInput.Value
    }
    
    ; Initial load
    LoadDirectory(currentPath)
    
    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => (IL_Destroy(ImageListID), myGui.Destroy()))
    
    myGui.OnEvent("Close", (*) => (IL_Destroy(ImageListID), myGui.Destroy()))
    myGui.Show()
}

;=============================================================================
; EXAMPLE 4: Drive Explorer
;=============================================================================
; Complete drive and directory explorer

Example4_DriveExplorer() {
    myGui := Gui("+Resize", "Example 4: Drive Explorer")
    
    ; Create TreeView
    ImageListID := IL_Create(15)
    DriveIcon := IL_Add(ImageListID, "shell32.dll", 9)
    FolderIcon := IL_Add(ImageListID, "shell32.dll", 4)
    FileIcon := IL_Add(ImageListID, "shell32.dll", 1)
    
    TV := myGui.Add("TreeView", "w600 h400 ImageList" . ImageListID)
    
    ; Add all drives
    Loop 26 {
        driveLetter := Chr(64 + A_Index)
        drive := driveLetter . ":\"
        
        if (DriveGetType(drive)) {
            driveLabel := DriveGetLabel(drive)
            driveType := DriveGetType(drive)
            
            displayName := drive
            if (driveLabel)
                displayName .= " (" . driveLabel . ")"
            displayName .= " - " . driveType
            
            driveNode := TV.Add(displayName, 0, "Icon" . DriveIcon)
            TV.Add("...", driveNode)  ; Placeholder
        }
    }
    
    ; Expanded nodes tracking
    expandedNodes := Map()
    
    ; Lazy load on expand
    TV.OnEvent("ItemExpand", OnExpand)
    
    OnExpand(GuiCtrl, ItemID) {
        if (expandedNodes.Has(ItemID))
            return
        
        expandedNodes[ItemID] := true
        
        ; Remove placeholder
        child := TV.GetChild(ItemID)
        if (child && TV.GetText(child) = "...")
            TV.Delete(child)
        
        ; Get drive path
        itemText := TV.GetText(ItemID)
        
        ; Extract drive letter
        RegExMatch(itemText, "([A-Z]):", &match)
        if (!match)
            return
        
        drivePath := match[1] . ":\"
        
        try {
            ; Add top-level folders
            Loop Files, drivePath . "*", "D" {
                if (A_LoopFileAttrib ~= "H|S")
                    continue
                
                folderNode := TV.Add(A_LoopFileName, ItemID, "Icon" . FolderIcon)
                
                ; Check if has subdirectories
                hasSubdirs := false
                try {
                    Loop Files, A_LoopFilePath . "\*", "D" {
                        hasSubdirs := true
                        break
                    }
                }
                
                if (hasSubdirs)
                    TV.Add("...", folderNode)
            }
        }
        catch as err {
            TV.Add("Access Denied", ItemID)
        }
    }
    
    ; Drive info display
    infoText := myGui.Add("Edit", "xm y+10 w600 h120 ReadOnly")
    
    ; Show drive info on selection
    TV.OnEvent("ItemSelect", ShowDriveInfo)
    
    ShowDriveInfo(*) {
        if (selected := TV.GetSelection()) {
            itemText := TV.GetText(selected)
            
            ; Check if it's a drive
            if (RegExMatch(itemText, "([A-Z]):\\", &match)) {
                drive := match[1] . ":\"
                
                info := "Drive: " . drive . "`n"
                info .= "Label: " . DriveGetLabel(drive) . "`n"
                info .= "Type: " . DriveGetType(drive) . "`n"
                info .= "Status: " . DriveGetStatus(drive) . "`n"
                
                capacity := DriveGetCapacity(drive)
                freeSpace := DriveGetSpaceFree(drive)
                usedSpace := capacity - freeSpace
                
                info .= "Capacity: " . FormatBytes(capacity * 1048576) . "`n"
                info .= "Free: " . FormatBytes(freeSpace * 1048576) . "`n"
                info .= "Used: " . FormatBytes(usedSpace * 1048576) . "`n"
                
                if (capacity > 0)
                    info .= "Usage: " . Round((usedSpace / capacity) * 100, 1) . "%"
                
                infoText.Value := info
            }
        }
    }
    
    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => (IL_Destroy(ImageListID), myGui.Destroy()))
    
    myGui.OnEvent("Close", (*) => (IL_Destroy(ImageListID), myGui.Destroy()))
    myGui.Show()
}

;=============================================================================
; EXAMPLE 5: File System with Icons by Type
;=============================================================================
; Browser that shows different icons based on file extension

Example5_IconsByType() {
    myGui := Gui("+Resize", "Example 5: Icons by File Type")
    
    ; Create TreeView
    ImageListID := IL_Create(20)
    
    ; Add icons for different file types
    Icons := Map(
        "folder", IL_Add(ImageListID, "shell32.dll", 4),
        "txt", IL_Add(ImageListID, "shell32.dll", 70),
        "ahk", IL_Add(ImageListID, "shell32.dll", 2),
        "exe", IL_Add(ImageListID, "shell32.dll", 2),
        "dll", IL_Add(ImageListID, "shell32.dll", 154),
        "jpg", IL_Add(ImageListID, "shell32.dll", 72),
        "png", IL_Add(ImageListID, "shell32.dll", 72),
        "mp3", IL_Add(ImageListID, "shell32.dll", 108),
        "mp4", IL_Add(ImageListID, "shell32.dll", 238),
        "zip", IL_Add(ImageListID, "shell32.dll", 165),
        "pdf", IL_Add(ImageListID, "shell32.dll", 71),
        "default", IL_Add(ImageListID, "shell32.dll", 1)
    )
    
    TV := myGui.Add("TreeView", "w600 h450 ImageList" . ImageListID)
    
    ; Browse button
    browseBtn := myGui.Add("Button", "xm y+10 w150", "Select Folder")
    browseBtn.OnEvent("Click", SelectFolder)
    
    currentPath := ""
    
    SelectFolder(*) {
        folder := DirSelect("*" . A_MyDocuments, 3, "Select a folder to browse")
        if (folder) {
            currentPath := folder
            LoadFolder(folder)
        }
    }
    
    LoadFolder(path) {
        TV.Delete()
        
        Root := TV.Add(path, 0, "Icon" . Icons["folder"])
        
        try {
            ; Add folders
            Loop Files, path . "\*", "D" {
                if (A_LoopFileAttrib ~= "H")
                    continue
                TV.Add(A_LoopFileName, Root, "Icon" . Icons["folder"])
            }
            
            ; Add files with appropriate icons
            Loop Files, path . "\*", "F" {
                if (A_LoopFileAttrib ~= "H")
                    continue
                
                ; Get extension
                SplitPath(A_LoopFileName, , , &ext)
                ext := StrLower(ext)
                
                ; Get appropriate icon
                icon := Icons.Has(ext) ? Icons[ext] : Icons["default"]
                
                TV.Add(A_LoopFileName, Root, "Icon" . icon)
            }
        }
        
        TV.Modify(Root, "Expand")
    }
    
    ; Instructions
    infoText := myGui.Add("Text", "xm y+10 w600",
        "Different file types display different icons. Select a folder to browse.")
    
    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => (IL_Destroy(ImageListID), myGui.Destroy()))
    
    myGui.OnEvent("Close", (*) => (IL_Destroy(ImageListID), myGui.Destroy()))
    myGui.Show()
}

;=============================================================================
; EXAMPLE 6: File System with Search
;=============================================================================
; Browse and search files in directory tree

Example6_FileSearch() {
    myGui := Gui("+Resize", "Example 6: File System Search")
    
    ; Create TreeView
    ImageListID := IL_Create(10)
    FolderIcon := IL_Add(ImageListID, "shell32.dll", 4)
    FileIcon := IL_Add(ImageListID, "shell32.dll", 71)
    
    TV := myGui.Add("TreeView", "w600 h350 ImageList" . ImageListID)
    
    ; Search controls
    myGui.Add("Text", "xm y+10", "Search:")
    searchInput := myGui.Add("Edit", "x+10 yp-3 w200")
    searchBtn := myGui.Add("Button", "x+10 yp-0 w100", "Find Files")
    searchBtn.OnEvent("Click", SearchFiles)
    
    myGui.Add("Text", "xm y+10", "In Folder:")
    folderInput := myGui.Add("Edit", "x+10 yp-3 w400 ReadOnly", A_MyDocuments)
    browseBtn := myGui.Add("Button", "x+10 yp-0 w100", "Browse")
    browseBtn.OnEvent("Click", BrowseFolder)
    
    BrowseFolder(*) {
        folder := DirSelect("*" . folderInput.Value, 3)
        if (folder)
            folderInput.Value := folder
    }
    
    SearchFiles(*) {
        searchTerm := searchInput.Value
        if (!searchTerm) {
            MsgBox("Please enter a search term", "Info", 64)
            return
        }
        
        TV.Delete()
        baseFolder := folderInput.Value
        
        Root := TV.Add("Search Results for: " . searchTerm, 0, "Icon" . FolderIcon)
        
        ; Search recursively
        results := 0
        try {
            Loop Files, baseFolder . "\*" . searchTerm . "*", "FR" {
                if (A_LoopFileAttrib ~= "H|S")
                    continue
                
                ; Get relative path
                relPath := StrReplace(A_LoopFileDir, baseFolder, "")
                if (relPath)
                    relPath := LTrim(relPath, "\")
                
                displayText := (relPath ? relPath . "\" : "") . A_LoopFileName
                TV.Add(displayText, Root, "Icon" . FileIcon)
                
                results++
                if (results >= 1000)  ; Limit results
                    break
            }
        }
        
        TV.Modify(Root, "Expand")
        
        if (results = 0)
            TV.Add("No results found", Root)
        else if (results >= 1000)
            TV.Add("... (showing first 1000 results)", Root)
    }
    
    ; Results status
    statusText := myGui.Add("Text", "xm y+10 w600", "Enter search term and click Find Files")
    
    ; Update status
    searchBtn.OnEvent("Click", (*) => (SetTimer(UpdateStatus, -100), ""))
    
    UpdateStatus() {
        count := TV.GetCount()
        statusText.Value := "Found " . (count - 1) . " matching files"
    }
    
    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => (IL_Destroy(ImageListID), myGui.Destroy()))
    
    myGui.OnEvent("Close", (*) => (IL_Destroy(ImageListID), myGui.Destroy()))
    myGui.Show()
}

;=============================================================================
; EXAMPLE 7: Complete File Manager
;=============================================================================
; Full-featured file manager with operations

Example7_FileManager() {
    myGui := Gui("+Resize", "Example 7: Complete File Manager")
    
    ; Create TreeView
    ImageListID := IL_Create(10)
    FolderIcon := IL_Add(ImageListID, "shell32.dll", 4)
    FileIcon := IL_Add(ImageListID, "shell32.dll", 71)
    
    TV := myGui.Add("TreeView", "w700 h400 ImageList" . ImageListID)
    
    ; Current path
    currentPath := A_MyDocuments
    
    ; Path display and controls
    myGui.Add("Text", "xm y+10", "Location:")
    pathEdit := myGui.Add("Edit", "x+10 yp-3 w500 ReadOnly", currentPath)
    
    refreshBtn := myGui.Add("Button", "x+10 yp-0 w80", "Refresh")
    refreshBtn.OnEvent("Click", (*) => LoadDirectory(currentPath))
    
    upBtn := myGui.Add("Button", "x+10 yp w80", "Up")
    upBtn.OnEvent("Click", GoUp)
    
    ; File operations
    myGui.Add("Text", "xm y+10", "Operations:")
    
    newFolderBtn := myGui.Add("Button", "xm y+5 w100", "New Folder")
    newFolderBtn.OnEvent("Click", CreateNewFolder)
    
    deleteBtn := myGui.Add("Button", "x+10 yp w100", "Delete")
    deleteBtn.OnEvent("Click", DeleteSelected)
    
    renameBtn := myGui.Add("Button", "x+10 yp w100", "Rename")
    renameBtn.OnEvent("Click", RenameSelected)
    
    openBtn := myGui.Add("Button", "x+10 yp w100", "Open")
    openBtn.OnEvent("Click", OpenSelected)
    
    LoadDirectory(path) {
        currentPath := path
        pathEdit.Value := path
        
        TV.Delete()
        Root := TV.Add(path, 0, "Icon" . FolderIcon)
        
        try {
            ; Add folders
            Loop Files, path . "\*", "D" {
                if (A_LoopFileAttrib ~= "H")
                    continue
                TV.Add(A_LoopFileName, Root, "Icon" . FolderIcon)
            }
            
            ; Add files
            Loop Files, path . "\*", "F" {
                if (A_LoopFileAttrib ~= "H")
                    continue
                TV.Add(A_LoopFileName, Root, "Icon" . FileIcon)
            }
        }
        
        TV.Modify(Root, "Expand")
        UpdateStatus()
    }
    
    GoUp(*) {
        SplitPath(currentPath, , &parentDir)
        if (parentDir)
            LoadDirectory(parentDir)
    }
    
    CreateNewFolder(*) {
        name := InputBox("Enter folder name:", "New Folder", "w300")
        if (name.Result = "OK" && name.Value) {
            newPath := currentPath . "\" . name.Value
            try {
                DirCreate(newPath)
                LoadDirectory(currentPath)
            }
            catch as err {
                MsgBox("Error creating folder: " . err.Message, "Error", 16)
            }
        }
    }
    
    DeleteSelected(*) {
        if (!(selected := TV.GetSelection()))
            return
        if (selected = TV.GetNext())  ; Don't delete root
            return
        
        itemText := TV.GetText(selected)
        result := MsgBox("Delete " . itemText . "?", "Confirm Delete", "YesNo 48")
        
        if (result = "Yes") {
            fullPath := currentPath . "\" . itemText
            try {
                if (FileExist(fullPath) & "D")
                    DirDelete(fullPath)
                else
                    FileDelete(fullPath)
                LoadDirectory(currentPath)
            }
            catch as err {
                MsgBox("Error deleting: " . err.Message, "Error", 16)
            }
        }
    }
    
    RenameSelected(*) {
        if (!(selected := TV.GetSelection()))
            return
        if (selected = TV.GetNext())  ; Don't rename root
            return
        
        oldName := TV.GetText(selected)
        newName := InputBox("Enter new name:", "Rename", "w300", oldName)
        
        if (newName.Result = "OK" && newName.Value && newName.Value != oldName) {
            oldPath := currentPath . "\" . oldName
            newPath := currentPath . "\" . newName.Value
            
            try {
                FileMove(oldPath, newPath)
                LoadDirectory(currentPath)
            }
            catch as err {
                MsgBox("Error renaming: " . err.Message, "Error", 16)
            }
        }
    }
    
    OpenSelected(*) {
        if (!(selected := TV.GetSelection()))
            return
        if (selected = TV.GetNext())  ; Root - do nothing
            return
        
        itemText := TV.GetText(selected)
        fullPath := currentPath . "\" . itemText
        
        if (FileExist(fullPath) & "D") {
            LoadDirectory(fullPath)
        } else {
            try {
                Run(fullPath)
            }
            catch as err {
                MsgBox("Error opening file: " . err.Message, "Error", 16)
            }
        }
    }
    
    ; Double-click to open
    TV.OnEvent("DoubleClick", OpenSelected)
    
    ; Status
    statusText := myGui.Add("Text", "xm y+10 w700", "")
    
    UpdateStatus() {
        fileCount := 0
        folderCount := 0
        
        try {
            Loop Files, currentPath . "\*", "D" {
                if (A_LoopFileAttrib ~= "H")
                    continue
                folderCount++
            }
            
            Loop Files, currentPath . "\*", "F" {
                if (A_LoopFileAttrib ~= "H")
                    continue
                fileCount++
            }
        }
        
        statusText.Value := folderCount . " folders, " . fileCount . " files"
    }
    
    ; Initial load
    LoadDirectory(currentPath)
    
    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => (IL_Destroy(ImageListID), myGui.Destroy()))
    
    myGui.OnEvent("Close", (*) => (IL_Destroy(ImageListID), myGui.Destroy()))
    myGui.Show()
}

;=============================================================================
; REFERENCE SECTION
;=============================================================================
/*
FILE SYSTEM FUNCTIONS:
- Loop Files, Pattern, Mode - Enumerate files/folders
  Mode: F=Files, D=Directories, R=Recurse
- FileExist(Path) - Check if file/folder exists
- DirCreate(Path) - Create directory
- DirDelete(Path) - Delete directory
- FileDelete(Path) - Delete file
- FileMove(Source, Dest) - Move/rename file
- DriveGet - Get drive information

FILE ATTRIBUTES:
- A = Archive
- D = Directory
- H = Hidden
- R = Read-only
- S = System

LAZY LOADING PATTERN:
1. Add dummy child to show expand icon
2. On ItemExpand event, remove dummy
3. Load actual directory contents
4. Track loaded nodes to prevent reloading

PERFORMANCE TIPS:
- Use lazy loading for large directories
- Limit file counts (first 100-1000)
- Skip hidden/system files
- Use try/catch for access errors
- Cache drive information
- Batch tree updates

BEST PRACTICES:
1. Handle access denied errors gracefully
2. Show loading indicators
3. Implement lazy loading for performance
4. Filter system/hidden files
5. Provide visual feedback during operations
6. Validate paths before operations
7. Show file sizes and dates

ERROR HANDLING:
- Wrap file operations in try/catch
- Check FileExist() before operations
- Validate paths and names
- Handle permission errors
- Provide user feedback on errors
*/

; Uncomment to run examples:
; Example1_SimpleBrowser()
; Example2_LazyLoading()
; Example3_FilteredBrowser()
; Example4_DriveExplorer()
; Example5_IconsByType()
; Example6_FileSearch()
; Example7_FileManager()
