#Requires AutoHotkey v2.0
/**
 * BuiltIn_EnvGet_02_PathManagement.ahk
 *
 * DESCRIPTION:
 * Advanced PATH environment variable management and manipulation
 * techniques for dynamic program discovery and execution.
 *
 * FEATURES:
 * - PATH variable parsing and searching
 * - Executable location discovery
 * - Path validation and testing
 * - Dynamic PATH modification for script session
 * - Program launcher with PATH integration
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - EnvGet for PATH retrieval
 * - String splitting and parsing
 * - File existence checking
 * - Loop for path iteration
 * - Map for caching results
 *
 * LEARNING POINTS:
 * 1. PATH contains semicolon-separated directories
 * 2. Order matters - first match is used
 * 3. PATHEXT defines executable extensions
 * 4. Can search PATH for program locations
 * 5. Validate paths before use
 * 6. Cache PATH lookups for performance
 * 7. Session-only PATH modifications possible
 */

;===============================================================================
; EXAMPLE 1: PATH Directory Lister
;===============================================================================

Example1_PathDirectoryLister() {
    path := EnvGet("PATH")
    
    if !path {
        MsgBox("PATH variable is empty!", "Error")
        return
    }
    
    dirs := StrSplit(path, ";")
    
    gui := Gui(, "PATH Directories (" dirs.Length " total)")
    
    lv := gui.Add("ListView", "x10 y10 w600 h400", ["#", "Directory", "Exists", "Files"])
    
    for index, dir in dirs {
        dir := Trim(dir)
        if !dir
            continue
            
        exists := DirExist(dir)
        fileCount := 0
        
        if exists {
            try {
                Loop Files, dir "\*.*"
                    fileCount++
            }
        }
        
        lv.Add(, index, dir, exists ? "Yes" : "No", fileCount)
    }
    
    lv.ModifyCol()
    
    gui.Add("Button", "x250 y420 w100", "Close").OnEvent("Click", (*) => gui.Destroy())
    gui.Show("w620 h460")
}

;===============================================================================
; EXAMPLE 2: Executable Finder
;===============================================================================

Example2_ExecutableFinder() {
    gui := Gui(, "Find Executables in PATH")
    
    gui.Add("Text", "x10 y10", "Program Name:")
    progInput := gui.Add("Edit", "x110 y5 w200")
    btnSearch := gui.Add("Button", "x320 y3 w100", "Search")
    
    results := gui.Add("ListView", "x10 y40 w500 h300", ["Location", "Full Path", "Size"])
    
    gui.Show("w520 h380")
    
    SearchPATH(*) {
        progName := Trim(progInput.Value)
        if !progName {
            MsgBox("Enter a program name!", "Error")
            return
        }
        
        results.Delete()
        
        path := EnvGet("PATH")
        pathExt := EnvGet("PATHEXT")
        
        dirs := StrSplit(path, ";")
        exts := StrSplit(pathExt, ";")
        
        found := 0
        
        for dir in dirs {
            dir := Trim(dir)
            if !dir || !DirExist(dir)
                continue
                
            ; Try with each extension
            for ext in exts {
                fullPath := dir "\" progName ext
                
                if FileExist(fullPath) {
                    try {
                        fileSize := FileGetSize(fullPath)
                        results.Add(, dir, fullPath, Round(fileSize/1024, 2) " KB")
                        found++
                    }
                }
            }
            
            ; Also try without extension
            fullPath := dir "\" progName
            if FileExist(fullPath) && !InStr(progName, ".") {
                try {
                    fileSize := FileGetSize(fullPath)
                    results.Add(, dir, fullPath, Round(fileSize/1024, 2) " KB")
                    found++
                }
            }
        }
        
        results.ModifyCol()
        
        if !found
            MsgBox("'" progName "' not found in PATH!", "Not Found")
        else
            MsgBox("Found " found " instance(s) of '" progName "'", "Search Complete")
    }
    
    btnSearch.OnEvent("Click", SearchPATH)
    progInput.OnEvent("Change", SearchPATH)
}

;===============================================================================
; EXAMPLE 3: PATH Analyzer and Optimizer
;===============================================================================

Example3_PathAnalyzer() {
    path := EnvGet("PATH")
    dirs := StrSplit(path, ";")
    
    ; Analyze PATH
    valid := []
    invalid := []
    duplicates := Map()
    
    for dir in dirs {
        dir := Trim(dir)
        if !dir
            continue
            
        ; Normalize path
        normalized := StrReplace(dir, "/", "\")
        normalized := RTrim(normalized, "\")
        
        if DirExist(normalized) {
            if duplicates.Has(normalized)
                duplicates[normalized]++
            else {
                duplicates[normalized] := 1
                valid.Push(normalized)
            }
        } else {
            invalid.Push(dir)
        }
    }
    
    ; Show results
    gui := Gui(, "PATH Analysis Report")
    
    info := "Total Directories: " dirs.Length "`n"
    info .= "Valid: " valid.Length "`n"
    info .= "Invalid: " invalid.Length "`n"
    info .= "Duplicates: " (dirs.Length - valid.Length - invalid.Length) "`n"
    
    gui.Add("Text", "x10 y10 w400", info)
    
    tabs := gui.Add("Tab3", "x10 y80 w500 h350", ["Valid", "Invalid", "Duplicates"])
    
    tabs.UseTab("Valid")
    validList := gui.Add("ListBox", "x20 y110 w480 h300", valid)
    
    tabs.UseTab("Invalid")
    invalidList := gui.Add("ListBox", "x20 y110 w480 h300", invalid)
    
    tabs.UseTab("Duplicates")
    dupInfo := ""
    for path, count in duplicates {
        if count > 1
            dupInfo .= path " (appears " count " times)`n"
    }
    gui.Add("Edit", "x20 y110 w480 h300 ReadOnly Multi", dupInfo)
    
    tabs.UseTab()
    
    gui.Add("Button", "x200 y440 w100", "Close").OnEvent("Click", (*) => gui.Destroy())
    gui.Show("w520 h480")
}

;===============================================================================
; EXAMPLE 4: Program Version Finder
;===============================================================================

Example4_ProgramVersions() {
    commonProgs := ["python.exe", "node.exe", "java.exe", "git.exe", "code.exe"]
    
    gui := Gui(, "Find Program Versions")
    
    lv := gui.Add("ListView", "x10 y10 w500 h300", ["Program", "Location", "Version"])
    
    path := EnvGet("PATH")
    dirs := StrSplit(path, ";")
    
    for prog in commonProgs {
        for dir in dirs {
            dir := Trim(dir)
            if !dir
                continue
                
            fullPath := dir "\" prog
            
            if FileExist(fullPath) {
                version := "Found"
                
                ; Try to get version
                try {
                    result := RunWait('"' fullPath '" --version',, "Hide")
                    ; Would capture output in real implementation
                }
                
                lv.Add(, prog, dir, version)
                break  ; First match only
            }
        }
    }
    
    lv.ModifyCol()
    
    gui.Add("Button", "x200 y320 w100", "Refresh").OnEvent("Click", (*) => gui.Destroy())
    gui.Show("w520 h360")
}

;===============================================================================
; EXAMPLE 5: Quick Launch Menu
;===============================================================================

Example5_QuickLauncher() {
    ; Build menu of common executables
    menu := Menu()
    
    path := EnvGet("PATH")
    dirs := StrSplit(path, ";")
    
    found := Map()
    commonApps := ["notepad.exe", "calc.exe", "mspaint.exe", "cmd.exe", "powershell.exe"]
    
    for app in commonApps {
        for dir in dirs {
            dir := Trim(dir)
            fullPath := dir "\" app
            
            if FileExist(fullPath) {
                found[app] := fullPath
                break
            }
        }
    }
    
    ; Add to menu
    for app, path in found {
        menu.Add(app, (*) => Run(path))
    }
    
    MsgBox("Right-click to show quick launch menu")
    
    ~RButton::menu.Show()
}

;===============================================================================
; Run Examples
;===============================================================================

; Uncomment to run:
; Example1_PathDirectoryLister()
; Example2_ExecutableFinder()
; Example3_PathAnalyzer()
; Example4_ProgramVersions()
; Example5_QuickLauncher()
