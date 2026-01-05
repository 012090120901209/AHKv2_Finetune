#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_COM_IE_05_JavaScript.ahk
 * 
 * DESCRIPTION:
 * JavaScript execution in IE using COM automation.
 * 
 * FEATURES:
 * - Execute JavaScript
 * - Access window object
 * - Call JS functions
 * - Get return values
 * - DOM manipulation via JS
 */

Example1_ExecuteJS() {
    MsgBox("Example 1: Execute JavaScript")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        ie.Navigate("about:blank")
        while ie.Busy
            Sleep(100)
        ie.Document.parentWindow.execScript("alert('Hello from JS!')", "JavaScript")
        MsgBox("JS executed!")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example2_CreateFunction() {
    MsgBox("Example 2: Create JS Function")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        ie.Navigate("about:blank")
        while ie.Busy
            Sleep(100)
        ie.Document.parentWindow.execScript("function test() { return 'Test'; }", "JavaScript")
        MsgBox("Function created!")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example3_ModifyDOM() {
    MsgBox("Example 3: Modify DOM via JS")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        ie.Document.write("<div id='target'>Original</div>")
        Sleep(500)
        js := "document.getElementById('target').innerHTML = 'Modified by JS';"
        ie.Document.parentWindow.execScript(js, "JavaScript")
        MsgBox("DOM modified via JS!")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example4_GetValue() {
    MsgBox("Example 4: Get JS Value")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        ie.Navigate("about:blank")
        while ie.Busy
            Sleep(100)
        result := ie.Document.parentWindow.eval("2 + 2")
        MsgBox("Result: " result)
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example5_WindowObject() {
    MsgBox("Example 5: Access Window Object")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        ie.Navigate("about:blank")
        while ie.Busy
            Sleep(100)
        width := ie.Document.parentWindow.screen.width
        height := ie.Document.parentWindow.screen.height
        MsgBox("Screen: " width "x" height)
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example6_CallFunction() {
    MsgBox("Example 6: Call JS Function")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        ie.Navigate("about:blank")
        while ie.Busy
            Sleep(100)
        ie.Document.parentWindow.execScript("function add(a,b) { return a+b; }", "JavaScript")
        MsgBox("Function ready to call")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example7_ConsoleLog() {
    MsgBox("Example 7: Console Operations")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        ie.Navigate("about:blank")
        while ie.Busy
            Sleep(100)
        ie.Document.parentWindow.execScript("console.log('Test message')", "JavaScript")
        MsgBox("Check IE console (F12)")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

ShowMenu() {
    menu := "
    (
    IE COM - JavaScript

    1. Execute JS
    2. Create Function
    3. Modify DOM
    4. Get JS Value
    5. Window Object
    6. Call Function
    7. Console Operations

    0. Exit
    )"
    choice := InputBox(menu, "JavaScript Examples", "w300 h400").Value
    switch choice {
        case "1": Example1_ExecuteJS()
        case "2": Example2_CreateFunction()
        case "3": Example3_ModifyDOM()
        case "4": Example4_GetValue()
        case "5": Example5_WindowObject()
        case "6": Example6_CallFunction()
        case "7": Example7_ConsoleLog()
        case "0": return
        default: MsgBox("Invalid!")
    }
    if MsgBox("Run another?", "Continue?", "YesNo") = "Yes"
        ShowMenu()
}
ShowMenu()
