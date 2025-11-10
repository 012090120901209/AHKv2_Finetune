#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * File and Folder Operations
 *
 * Demonstrates Explorer integration for copying file paths,
 * filenames, and accessing the Recycle Bin.
 *
 * Source: xypha/AHK-v2-scripts - Showcase.ahk
 * Inspired by: https://github.com/xypha/AHK-v2-scripts
 */

MsgBox("File Operations Demo`n`n"
     . "Features:`n"
     . "1. Copy full path of selected file(s)`n"
     . "2. Copy filename(s) only`n"
     . "3. Quick access to Recycle Bin`n`n"
     . "Hotkeys:`n"
     . "Ctrl+Shift+C - Copy full path`n"
     . "Ctrl+Shift+N - Copy filename`n"
     . "Ctrl+Delete - Open Recycle Bin`n`n"
     . "Opening Explorer for demo...", , "T5")

; Open Explorer to demonstrate
Run("explorer.exe " A_ScriptDir)
WinWait("ahk_class CabinetWClass", , 3)
WinActivate("ahk_class CabinetWClass")

MsgBox("Select a file in Explorer and try:`n"
     . "Ctrl+Shift+C to copy its path!", , "T3")

; Copy full path (Explorer context)
#HotIf WinActive("ahk_class CabinetWClass") || WinActive("ahk_class #32770")
^+c::CopySelectedPaths()
^+n::CopySelectedFilenames()
#HotIf

; Quick Recycle Bin access
^Delete::OpenRecycleBin()

/**
 * Copy full paths of selected files
 */
CopySelectedPaths() {
    paths := GetSelectedFilePaths()

    if (paths.Length == 0) {
        ToolTip("No files selected")
        SetTimer(() => ToolTip(), -1500)
        return
    }

    ; Join paths with newline
    pathText := ""
    for path in paths
        pathText .= path "`n"
    pathText := RTrim(pathText, "`n")

    ; Copy to clipboard
    A_Clipboard := pathText

    ; Show notification
    count := paths.Length
    preview := paths[1]
    if (StrLen(preview) > 60)
        preview := SubStr(preview, 1, 60) "..."

    ToolTip("Copied " count " path(s):`n" preview)
    SetTimer(() => ToolTip(), -2000)
}

/**
 * Copy filenames only (no path)
 */
CopySelectedFilenames() {
    paths := GetSelectedFilePaths()

    if (paths.Length == 0) {
        ToolTip("No files selected")
        SetTimer(() => ToolTip(), -1500)
        return
    }

    ; Extract filenames
    filenames := []
    for path in paths {
        SplitPath(path, &filename)
        filenames.Push(filename)
    }

    ; Join with newline
    filenameText := ""
    for name in filenames
        filenameText .= name "`n"
    filenameText := RTrim(filenameText, "`n")

    ; Copy to clipboard
    A_Clipboard := filenameText

    ; Show notification
    ToolTip("Copied " filenames.Length " filename(s):`n" filenames[1])
    SetTimer(() => ToolTip(), -2000)
}

/**
 * Get selected file paths from Explorer
 */
GetSelectedFilePaths() {
    paths := []

    try {
        ; Get active Explorer window
        for window in ComObject("Shell.Application").Windows {
            if (window.HWND == WinExist("A")) {
                ; Get selected items
                for item in window.Document.SelectedItems {
                    paths.Push(item.Path)
                }
                break
            }
        }
    } catch {
        ; Fallback: try to get from clipboard
        return []
    }

    return paths
}

/**
 * Open Recycle Bin
 */
OpenRecycleBin() {
    ; Open Recycle Bin using shell command
    Run("explorer.exe shell:RecycleBinFolder")

    ToolTip("Opening Recycle Bin...")
    SetTimer(() => ToolTip(), -1500)
}

/*
 * Key Concepts:
 *
 * 1. Shell.Application COM:
 *    ComObject("Shell.Application")
 *    Access to Explorer windows
 *    File system operations
 *
 * 2. Explorer Integration:
 *    Windows property - All windows
 *    Document.SelectedItems - Selection
 *    HWND matching - Active window
 *
 * 3. File Path Operations:
 *    SplitPath() - Extract components
 *    path, filename, ext, name, drive
 *    Join/split operations
 *
 * 4. Context-Sensitive Hotkeys:
 *    #HotIf WinActive("ahk_class CabinetWClass")
 *    Only in Explorer windows
 *    Also works in Open/Save dialogs (#32770)
 *
 * 5. Shell Commands:
 *    shell:RecycleBinFolder - Recycle Bin
 *    shell:MyComputerFolder - This PC
 *    shell:Desktop - Desktop
 *    shell:Downloads - Downloads
 *
 * 6. Use Cases:
 *    ✅ Paste paths in terminals
 *    ✅ Documentation references
 *    ✅ Batch scripts
 *    ✅ Bug reports with paths
 *    ✅ Quick file access
 *
 * 7. Multiple Selection:
 *    Loop through SelectedItems
 *    Join with newlines
 *    Works with 1 or many files
 *
 * 8. SplitPath Components:
 *    Path - Full path
 *    Filename - Name with extension
 *    Name - Without extension
 *    Ext - Extension only
 *    Drive - Drive letter
 *
 * 9. Best Practices:
 *    ✅ Handle no selection
 *    ✅ Show count in feedback
 *    ✅ Preview first item
 *    ✅ Error handling
 *
 * 10. Related Operations:
 *     - Copy parent folder path
 *     - Copy as relative path
 *     - Copy with quotes
 *     - Copy as UNC path
 *     - Copy as URI
 *
 * 11. Special Folders:
 *     shell:Desktop
 *     shell:Documents
 *     shell:Downloads
 *     shell:Pictures
 *     shell:AppData
 *     shell:ProgramFiles
 *
 * 12. Enhancements:
 *     - Format options (quotes, backslash/forward)
 *     - Copy as markdown link
 *     - Copy file contents
 *     - Generate file tree
 *     - Export to various formats
 *     - Right-click menu integration
 */
