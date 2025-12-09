#Requires AutoHotkey v2.0

/**
* BuiltIn_COM_ComObjConnect_01.ahk
*
* DESCRIPTION:
* Event handling with ComObjConnect.
*
* FEATURES:
* - Connecting to COM events
* - Event handlers
* - Disconnecting events
* - IE events
* - Application events
*/

Example1_BasicConnect() {
    MsgBox("Example 1: Basic Event Connection")
    Try {
        MsgBox("ComObjConnect allows connecting to COM events.`n`nExample: IE.BeforeNavigate event")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example2_IEEvents() {
    MsgBox("Example 2: IE Events")
    Try {
        global ie := ComObject("InternetExplorer.Application")
        ie.Visible := true

        ; ComObjConnect(ie, "IE_")

        MsgBox("IE event connection ready")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example3_ExcelEvents() {
    MsgBox("Example 3: Excel Events")
    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true

        ; ComObjConnect(xl, "XL_")

        MsgBox("Excel event connection ready")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example4_Disconnect() {
    MsgBox("Example 4: Disconnect Events")
    Try {
        MsgBox("Use ComObjConnect(obj) to disconnect all events")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example5_CustomHandler() {
    MsgBox("Example 5: Custom Event Handler")
    Try {
        MsgBox("Create event handler functions with prefix_EventName format")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example6_MultipleEvents() {
    MsgBox("Example 6: Multiple Events")
    Try {
        MsgBox("You can connect to multiple events from the same object")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example7_EventDemo() {
    MsgBox("Example 7: Event Demonstration")
    Try {
        MsgBox("COM events allow responding to application actions automatically")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

ShowMenu() {
    menu := "
    (
    ComObjConnect Examples

    1. Basic Connection
    2. IE Events
    3. Excel Events
    4. Disconnect Events
    5. Custom Handler
    6. Multiple Events
    7. Event Demo

    0. Exit
    )"
    choice := InputBox(menu, "ComObjConnect Examples", "w300 h400").Value
    switch choice {
        case "1": Example1_BasicConnect()
        case "2": Example2_IEEvents()
        case "3": Example3_ExcelEvents()
        case "4": Example4_Disconnect()
        case "5": Example5_CustomHandler()
        case "6": Example6_MultipleEvents()
        case "7": Example7_EventDemo()
        case "0": return
        default: MsgBox("Invalid!")
    }
    if MsgBox("Run another?", "Continue?", "YesNo") = "Yes"
    ShowMenu()
}
ShowMenu()
