#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_COM_Shell_01_Files.ahk
 * 
 * DESCRIPTION:
 * File operations using Windows Shell COM automation.
 * 
 * FEATURES:
 * - Shell file operations
 * - Folder browsing
 * - File properties
 * - Shell namespace
 * - Special folders
 */

Example1_CreateShell() {
    MsgBox("Example 1: Create Shell Object")
    Try {
        shell := ComObject("Shell.Application")
        MsgBox("Shell object created!")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example2_BrowseFolder() {
    MsgBox("Example 2: Browse for Folder")
    Try {
        shell := ComObject("Shell.Application")
        folder := shell.BrowseForFolder(0, "Select a folder", 0, 0)
        if (folder)
            MsgBox("Selected: " folder.Self.Path)
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example3_SpecialFolder() {
    MsgBox("Example 3: Get Special Folder")
    Try {
        shell := ComObject("Shell.Application")
        desktop := shell.NameSpace(0)  ; Desktop
        MsgBox("Desktop path: " desktop.Self.Path)
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example4_ListFiles() {
    MsgBox("Example 4: List Files")
    Try {
        shell := ComObject("Shell.Application")
        folder := shell.NameSpace(A_Temp)
        output := "Files in Temp:`n`n"
        for item in folder.Items() {
            output .= item.Name "`n"
            if (A_Index > 10)
                break
        }
        MsgBox(output)
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example5_FileProperties() {
    MsgBox("Example 5: Get File Properties")
    Try {
        shell := ComObject("Shell.Application")
        folder := shell.NameSpace(A_WinDir)
        item := folder.ParseName("notepad.exe")
        if (item)
            MsgBox("File: " item.Name "`nSize: " item.Size)
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example6_OpenFolder() {
    MsgBox("Example 6: Open Folder")
    Try {
        shell := ComObject("Shell.Application")
        shell.Open(A_Temp)
        MsgBox("Folder opened!")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example7_MinimizeAll() {
    MsgBox("Example 7: Minimize All")
    Try {
        shell := ComObject("Shell.Application")
        ; shell.MinimizeAll()
        MsgBox("MinimizeAll available")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

ShowMenu() {
    menu := "
    (
    Shell COM - File Operations

    1. Create Shell
    2. Browse Folder
    3. Special Folder
    4. List Files
    5. File Properties
    6. Open Folder
    7. Minimize All

    0. Exit
    )"
    choice := InputBox(menu, "Shell Examples", "w300 h400").Value
    switch choice {
        case "1": Example1_CreateShell()
        case "2": Example2_BrowseFolder()
        case "3": Example3_SpecialFolder()
        case "4": Example4_ListFiles()
        case "5": Example5_FileProperties()
        case "6": Example6_OpenFolder()
        case "7": Example7_MinimizeAll()
        case "0": return
        default: MsgBox("Invalid!")
    }
    if MsgBox("Run another?", "Continue?", "YesNo") = "Yes"
        ShowMenu()
}
ShowMenu()
