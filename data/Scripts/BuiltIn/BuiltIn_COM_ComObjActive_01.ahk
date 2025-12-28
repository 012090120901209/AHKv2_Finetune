#Requires AutoHotkey v2.0

/**
 * BuiltIn_COM_ComObjActive_01.ahk
 * 
 * DESCRIPTION:
 * Using ComObjActive to connect to existing COM objects.
 * 
 * FEATURES:
 * - Getting active instances
 * - Connecting to running applications
 * - Reusing existing objects
 * - Error handling
 * - Multiple instances
 */

Example1_GetActiveExcel() {
    MsgBox("Example 1: Get Active Excel")
    Try {
        xl := ComObjActive("Excel.Application")
        xl.Visible := true
        MsgBox("Connected to active Excel!`nWorkbooks: " xl.Workbooks.Count)
    } Catch {
        MsgBox("No active Excel instance found.`nPlease open Excel first.")
    }
}

Example2_GetActiveWord() {
    MsgBox("Example 2: Get Active Word")
    Try {
        word := ComObjActive("Word.Application")
        word.Visible := true
        MsgBox("Connected to active Word!`nDocuments: " word.Documents.Count)
    } Catch {
        MsgBox("No active Word instance found.`nPlease open Word first.")
    }
}

Example3_GetActiveOutlook() {
    MsgBox("Example 3: Get Active Outlook")
    Try {
        outlook := ComObjActive("Outlook.Application")
        MsgBox("Connected to active Outlook!")
    } Catch {
        MsgBox("No active Outlook instance found.`nPlease open Outlook first.")
    }
}

Example4_ModifyActiveExcel() {
    MsgBox("Example 4: Modify Active Excel")
    Try {
        xl := ComObjActive("Excel.Application")
        if (xl.Workbooks.Count > 0) {
            sheet := xl.ActiveSheet
            sheet.Range("A1").Value := "Modified by AHK!"
            MsgBox("Excel modified!")
        } else {
            MsgBox("No active workbook")
        }
    } Catch {
        MsgBox("No active Excel instance")
    }
}

Example5_ActiveOrNew() {
    MsgBox("Example 5: Active or Create New")
    Try {
        Try {
            xl := ComObjActive("Excel.Application")
            MsgBox("Using existing Excel instance")
        } Catch {
            xl := ComObject("Excel.Application")
            MsgBox("Created new Excel instance")
        }
        xl.Visible := true
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example6_CloseActive() {
    MsgBox("Example 6: Close Active Instance")
    Try {
        xl := ComObjActive("Excel.Application")
        response := MsgBox("Close active Excel?", "Confirm", "YesNo")
        if (response = "Yes") {
            xl.Quit()
            MsgBox("Excel closed!")
        }
    } Catch {
        MsgBox("No active Excel instance")
    }
}

Example7_CountInstances() {
    MsgBox("Example 7: Check for Instance")
    Try {
        Try {
            xl := ComObjActive("Excel.Application")
            MsgBox("Excel IS running")
        } Catch {
            MsgBox("Excel is NOT running")
        }
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

ShowMenu() {
    menu := "
    (
    ComObjActive Examples

    1. Get Active Excel
    2. Get Active Word
    3. Get Active Outlook
    4. Modify Active Excel
    5. Active or Create New
    6. Close Active Instance
    7. Check for Instance

    0. Exit
    )"
    choice := InputBox(menu, "ComObjActive Examples", "w300 h400").Value
    switch choice {
        case "1": Example1_GetActiveExcel()
        case "2": Example2_GetActiveWord()
        case "3": Example3_GetActiveOutlook()
        case "4": Example4_ModifyActiveExcel()
        case "5": Example5_ActiveOrNew()
        case "6": Example6_CloseActive()
        case "7": Example7_CountInstances()
        case "0": return
        default: MsgBox("Invalid!")
    }
    if MsgBox("Run another?", "Continue?", "YesNo") = "Yes"
        ShowMenu()
}
ShowMenu()
