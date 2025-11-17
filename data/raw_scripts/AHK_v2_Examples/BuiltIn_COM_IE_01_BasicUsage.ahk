#Requires AutoHotkey v2.0
/**
 * BuiltIn_COM_IE_01_BasicUsage.ahk
 *
 * DESCRIPTION:
 * Basic Internet Explorer automation using COM objects.
 *
 * FEATURES:
 * - Creating IE instances
 * - Navigation
 * - Page loading
 * - Document access
 * - Window control
 *
 * SOURCE:
 * AutoHotkey v2 Documentation - ComObject
 * https://www.autohotkey.com/docs/v2/lib/ComObject.htm
 */

Example1_OpenIE() {
    MsgBox("Example 1: Open IE")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        ie.Navigate("about:blank")
        while ie.Busy or ie.ReadyState != 4
            Sleep(100)
        MsgBox("IE opened!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example2_NavigateURL() {
    MsgBox("Example 2: Navigate URL")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        ie.Navigate("https://www.example.com")
        while ie.Busy
            Sleep(100)
        MsgBox("Navigated!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example3_GetTitle() {
    MsgBox("Example 3: Get Page Title")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        ie.Navigate("https://www.example.com")
        while ie.Busy
            Sleep(100)
        MsgBox("Title: " ie.Document.title)
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example4_GetURL() {
    MsgBox("Example 4: Get Current URL")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        ie.Navigate("https://www.example.com")
        while ie.Busy
            Sleep(100)
        MsgBox("URL: " ie.LocationURL)
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example5_BackForward() {
    MsgBox("Example 5: Navigation Controls")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        ie.Navigate("https://www.example.com")
        Sleep(2000)
        ; ie.GoBack()
        ; ie.GoForward()
        ; ie.Refresh()
        MsgBox("Navigation methods available")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example6_WindowSize() {
    MsgBox("Example 6: Window Size")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        ie.Width := 800
        ie.Height := 600
        ie.Navigate("about:blank")
        MsgBox("Window resized!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example7_MultipleWindows() {
    MsgBox("Example 7: Multiple Windows")
    Try {
        Loop 3 {
            ie := ComObject("InternetExplorer.Application")
            ie.Visible := true
            ie.Navigate("about:blank")
        }
        MsgBox("3 IE windows created!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

ShowMenu() {
    menu := "(
    IE COM - Basic Usage
    
    1. Open IE
    2. Navigate URL
    3. Get Page Title
    4. Get Current URL
    5. Navigation Controls
    6. Window Size
    7. Multiple Windows
    
    0. Exit
    )"
    choice := InputBox(menu, "IE Examples", "w300 h400").Value
    switch choice {
        case "1": Example1_OpenIE()
        case "2": Example2_NavigateURL()
        case "3": Example3_GetTitle()
        case "4": Example4_GetURL()
        case "5": Example5_BackForward()
        case "6": Example6_WindowSize()
        case "7": Example7_MultipleWindows()
        case "0": return
        default: MsgBox("Invalid!")
    }
    if MsgBox("Run another?", "Continue?", "YesNo") = "Yes"
        ShowMenu()
}
ShowMenu()
