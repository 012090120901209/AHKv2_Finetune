#Requires AutoHotkey v2.0

/**
 * BuiltIn_COM_ComObjGet_01.ahk
 * 
 * DESCRIPTION:
 * Using ComObjGet to retrieve COM objects.
 * 
 * FEATURES:
 * - Getting objects by moniker
 * - WMI connections
 * - File system objects
 * - Running objects
 * - Special objects
 */

Example1_GetWMI() {
    MsgBox("Example 1: Get WMI Object")
    Try {
        wmi := ComObjGet("winmgmts:")
        MsgBox("WMI object retrieved!")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example2_GetFileSystem() {
    MsgBox("Example 2: Get File System Object")
    Try {
        fso := ComObject("Scripting.FileSystemObject")
        drives := fso.Drives
        MsgBox("Drive count: " drives.Count)
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example3_GetShell() {
    MsgBox("Example 3: Get Shell Object")
    Try {
        shell := ComObject("Shell.Application")
        windows := shell.Windows()
        MsgBox("Shell windows: " windows.Count)
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example4_GetADSI() {
    MsgBox("Example 4: Get ADSI Object")
    Try {
        MsgBox("ADSI (Active Directory Service Interfaces) can be accessed via ComObjGet")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example5_GetROT() {
    MsgBox("Example 5: Running Object Table")
    Try {
        MsgBox("ComObjGet can access objects in the Running Object Table (ROT)")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example6_NetworkObject() {
    MsgBox("Example 6: Network Object")
    Try {
        net := ComObject("WScript.Network")
        MsgBox("Computer: " net.ComputerName "`nUser: " net.UserName)
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example7_CustomMoniker() {
    MsgBox("Example 7: Custom Moniker")
    Try {
        MsgBox("ComObjGet can use custom monikers to access specific objects")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

ShowMenu() {
    menu := "
    (
    ComObjGet Examples

    1. Get WMI
    2. File System Object
    3. Get Shell
    4. Get ADSI
    5. Running Object Table
    6. Network Object
    7. Custom Moniker

    0. Exit
    )"
    choice := InputBox(menu, "ComObjGet Examples", "w300 h400").Value
    switch choice {
        case "1": Example1_GetWMI()
        case "2": Example2_GetFileSystem()
        case "3": Example3_GetShell()
        case "4": Example4_GetADSI()
        case "5": Example5_GetROT()
        case "6": Example6_NetworkObject()
        case "7": Example7_CustomMoniker()
        case "0": return
        default: MsgBox("Invalid!")
    }
    if MsgBox("Run another?", "Continue?", "YesNo") = "Yes"
        ShowMenu()
}
ShowMenu()
