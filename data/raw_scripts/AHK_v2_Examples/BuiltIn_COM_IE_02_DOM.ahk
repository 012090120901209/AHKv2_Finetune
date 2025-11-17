#Requires AutoHotkey v2.0
/**
 * BuiltIn_COM_IE_02_DOM.ahk
 *
 * DESCRIPTION:
 * DOM manipulation in Internet Explorer using COM.
 *
 * FEATURES:
 * - Accessing elements
 * - Reading content
 * - Modifying HTML
 * - Element properties
 * - DOM traversal
 */

Example1_GetElement() {
    MsgBox("Example 1: Get Element by ID")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        ie.Document.write("<div id='test'>Hello</div>")
        elem := ie.Document.getElementById("test")
        MsgBox("Element: " elem.innerText)
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example2_GetByTag() {
    MsgBox("Example 2: Get Elements by Tag")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        ie.Document.write("<p>Para 1</p><p>Para 2</p>")
        elements := ie.Document.getElementsByTagName("p")
        MsgBox("Found " elements.length " paragraphs")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example3_ModifyHTML() {
    MsgBox("Example 3: Modify HTML")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        ie.Document.write("<div id='content'>Original</div>")
        Sleep(500)
        elem := ie.Document.getElementById("content")
        elem.innerHTML := "<b>Modified!</b>"
        MsgBox("HTML modified!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example4_GetText() {
    MsgBox("Example 4: Get Text Content")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        ie.Document.write("<div>Test content</div>")
        text := ie.Document.body.innerText
        MsgBox("Text: " text)
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example5_CreateElement() {
    MsgBox("Example 5: Create Element")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        ie.Document.write("<body></body>")
        newDiv := ie.Document.createElement("div")
        newDiv.innerHTML := "New element!"
        ie.Document.body.appendChild(newDiv)
        MsgBox("Element created!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example6_RemoveElement() {
    MsgBox("Example 6: Remove Element")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        ie.Document.write("<div id='remove'>Remove me</div>")
        Sleep(500)
        elem := ie.Document.getElementById("remove")
        elem.parentNode.removeChild(elem)
        MsgBox("Element removed!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example7_StyleElement() {
    MsgBox("Example 7: Style Element")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        ie.Document.write("<div id='styled'>Style me</div>")
        Sleep(500)
        elem := ie.Document.getElementById("styled")
        elem.style.color := "red"
        elem.style.fontSize := "20px"
        MsgBox("Element styled!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

ShowMenu() {
    menu := "(
    IE COM - DOM
    
    1. Get Element by ID
    2. Get by Tag
    3. Modify HTML
    4. Get Text
    5. Create Element
    6. Remove Element
    7. Style Element
    
    0. Exit
    )"
    choice := InputBox(menu, "DOM Examples", "w300 h400").Value
    switch choice {
        case "1": Example1_GetElement()
        case "2": Example2_GetByTag()
        case "3": Example3_ModifyHTML()
        case "4": Example4_GetText()
        case "5": Example5_CreateElement()
        case "6": Example6_RemoveElement()
        case "7": Example7_StyleElement()
        case "0": return
        default: MsgBox("Invalid!")
    }
    if MsgBox("Run another?", "Continue?", "YesNo") = "Yes"
        ShowMenu()
}
ShowMenu()
