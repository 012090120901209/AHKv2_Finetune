#Requires AutoHotkey v2.0
/**
 * BuiltIn_COM_Shell_03_Shortcuts.ahk
 *
 * DESCRIPTION:
 * Creating and managing shortcuts using WScript.Shell.
 *
 * FEATURES:
 * - Create shortcuts
 * - Set shortcut properties
 * - Read shortcut info
 * - Desktop shortcuts
 * - Start menu shortcuts
 */

Example1_CreateShortcut() {
    MsgBox("Example 1: Create Shortcut")
    Try {
        shell := ComObject("WScript.Shell")
        shortcut := shell.CreateShortcut(A_Desktop "\Test.lnk")
        shortcut.TargetPath := "notepad.exe"
        shortcut.WorkingDirectory := A_Temp
        shortcut.Save()
        MsgBox("Shortcut created on desktop!")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example2_ShortcutWithIcon() {
    MsgBox("Example 2: Shortcut with Icon")
    Try {
        shell := ComObject("WScript.Shell")
        shortcut := shell.CreateShortcut(A_Desktop "\Calculator.lnk")
        shortcut.TargetPath := "calc.exe"
        shortcut.IconLocation := "calc.exe,0"
        shortcut.Save()
        MsgBox("Shortcut with icon created!")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example3_ShortcutDescription() {
    MsgBox("Example 3: Shortcut Description")
    Try {
        shell := ComObject("WScript.Shell")
        shortcut := shell.CreateShortcut(A_Desktop "\MyApp.lnk")
        shortcut.TargetPath := "notepad.exe"
        shortcut.Description := "Opens Notepad"
        shortcut.Save()
        MsgBox("Shortcut with description created!")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example4_ShortcutHotkey() {
    MsgBox("Example 4: Shortcut with Hotkey")
    Try {
        shell := ComObject("WScript.Shell")
        shortcut := shell.CreateShortcut(A_Desktop "\Quick.lnk")
        shortcut.TargetPath := "calc.exe"
        shortcut.Hotkey := "CTRL+ALT+C"
        shortcut.Save()
        MsgBox("Shortcut with hotkey created!")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example5_ReadShortcut() {
    MsgBox("Example 5: Read Shortcut")
    Try {
        shell := ComObject("WScript.Shell")
        if FileExist(A_Desktop "\Test.lnk") {
            shortcut := shell.CreateShortcut(A_Desktop "\Test.lnk")
            MsgBox("Target: " shortcut.TargetPath)
        } else {
            MsgBox("Shortcut not found")
        }
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example6_URLShortcut() {
    MsgBox("Example 6: URL Shortcut")
    Try {
        shell := ComObject("WScript.Shell")
        shortcut := shell.CreateShortcut(A_Desktop "\Website.url")
        shortcut.TargetPath := "https://www.example.com"
        shortcut.Save()
        MsgBox("URL shortcut created!")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example7_StartMenuShortcut() {
    MsgBox("Example 7: Start Menu Shortcut")
    Try {
        shell := ComObject("WScript.Shell")
        startMenu := shell.SpecialFolders("StartMenu")
        shortcut := shell.CreateShortcut(startMenu "\MyApp.lnk")
        shortcut.TargetPath := "notepad.exe"
        shortcut.Save()
        MsgBox("Start menu shortcut created!")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

ShowMenu() {
    menu := "(
    Shell COM - Shortcuts
    
    1. Create Shortcut
    2. With Icon
    3. With Description
    4. With Hotkey
    5. Read Shortcut
    6. URL Shortcut
    7. Start Menu Shortcut
    
    0. Exit
    )"
    choice := InputBox(menu, "Shortcut Examples", "w300 h400").Value
    switch choice {
        case "1": Example1_CreateShortcut()
        case "2": Example2_ShortcutWithIcon()
        case "3": Example3_ShortcutDescription()
        case "4": Example4_ShortcutHotkey()
        case "5": Example5_ReadShortcut()
        case "6": Example6_URLShortcut()
        case "7": Example7_StartMenuShortcut()
        case "0": return
        default: MsgBox("Invalid!")
    }
    if MsgBox("Run another?", "Continue?", "YesNo") = "Yes"
        ShowMenu()
}
ShowMenu()
