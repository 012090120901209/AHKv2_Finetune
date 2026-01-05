#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_COM_Shell_02_Registry.ahk
 * 
 * DESCRIPTION:
 * Registry access using WScript.Shell COM object.
 * 
 * FEATURES:
 * - Read registry values
 * - Write registry values
 * - Delete registry keys
 * - Registry data types
 * - Environment variables
 */

Example1_ReadRegistry() {
    MsgBox("Example 1: Read Registry")
    Try {
        shell := ComObject("WScript.Shell")
        value := shell.RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Hidden")
        MsgBox("Registry value: " value)
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example2_WriteRegistry() {
    MsgBox("Example 2: Write Registry")
    Try {
        shell := ComObject("WScript.Shell")
        ; shell.RegWrite("HKEY_CURRENT_USER\Software\AHK_Test\TestValue", "TestData", "REG_SZ")
        MsgBox("Registry write ready (commented for safety)")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example3_DeleteRegistry() {
    MsgBox("Example 3: Delete Registry")
    Try {
        shell := ComObject("WScript.Shell")
        ; shell.RegDelete("HKEY_CURRENT_USER\Software\AHK_Test")
        MsgBox("Registry delete ready (commented for safety)")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example4_EnvironmentVar() {
    MsgBox("Example 4: Environment Variable")
    Try {
        shell := ComObject("WScript.Shell")
        env := shell.Environment("Process")
        path := env.Item("PATH")
        MsgBox("PATH: " SubStr(path, 1, 100) "...")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example5_ExpandString() {
    MsgBox("Example 5: Expand Environment")
    Try {
        shell := ComObject("WScript.Shell")
        expanded := shell.ExpandEnvironmentStrings("%USERPROFILE%")
        MsgBox("User Profile: " expanded)
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example6_SpecialFolders() {
    MsgBox("Example 6: Special Folders")
    Try {
        shell := ComObject("WScript.Shell")
        desktop := shell.SpecialFolders("Desktop")
        MsgBox("Desktop: " desktop)
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example7_RunCommand() {
    MsgBox("Example 7: Run Command")
    Try {
        shell := ComObject("WScript.Shell")
        ; shell.Run("notepad.exe", 1, false)
        MsgBox("Command ready to run")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

ShowMenu() {
    menu := "
    (
    Shell COM - Registry

    1. Read Registry
    2. Write Registry
    3. Delete Registry
    4. Environment Variable
    5. Expand String
    6. Special Folders
    7. Run Command

    0. Exit
    )"
    choice := InputBox(menu, "Registry Examples", "w300 h400").Value
    switch choice {
        case "1": Example1_ReadRegistry()
        case "2": Example2_WriteRegistry()
        case "3": Example3_DeleteRegistry()
        case "4": Example4_EnvironmentVar()
        case "5": Example5_ExpandString()
        case "6": Example6_SpecialFolders()
        case "7": Example7_RunCommand()
        case "0": return
        default: MsgBox("Invalid!")
    }
    if MsgBox("Run another?", "Continue?", "YesNo") = "Yes"
        ShowMenu()
}
ShowMenu()
