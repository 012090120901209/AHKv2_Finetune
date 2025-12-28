#Requires AutoHotkey v2.0

/**
 * BuiltIn_COM_IE_03_Forms.ahk
 * 
 * DESCRIPTION:
 * Form automation in Internet Explorer using COM.
 * 
 * FEATURES:
 * - Fill form fields
 * - Submit forms
 * - Select options
 * - Click buttons
 * - Form validation
 */

Example1_FillTextBox() {
    MsgBox("Example 1: Fill Text Box")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        ie.Document.write("<input type='text' id='name'>")
        Sleep(500)
        ie.Document.getElementById("name").value := "John Doe"
        MsgBox("Text box filled!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example2_CheckBox() {
    MsgBox("Example 2: Check Box")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        ie.Document.write("<input type='checkbox' id='agree'>")
        Sleep(500)
        ie.Document.getElementById("agree").checked := true
        MsgBox("Checkbox checked!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example3_RadioButton() {
    MsgBox("Example 3: Radio Button")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        ie.Document.write("<input type='radio' id='option1'><input type='radio' id='option2'>")
        Sleep(500)
        ie.Document.getElementById("option2").checked := true
        MsgBox("Radio selected!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example4_SelectDropdown() {
    MsgBox("Example 4: Select Dropdown")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        ie.Document.write("<select id='country'><option>USA</option><option>Canada</option></select>")
        Sleep(500)
        ie.Document.getElementById("country").selectedIndex := 1
        MsgBox("Dropdown selected!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example5_ClickButton() {
    MsgBox("Example 5: Click Button")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        ie.Document.write("<button id='btn' onclick='alert(`"Clicked!`")'>Click</button>")
        Sleep(500)
        ; ie.Document.getElementById("btn").click()
        MsgBox("Button ready to click")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example6_TextArea() {
    MsgBox("Example 6: Text Area")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        ie.Document.write("<textarea id='comment'></textarea>")
        Sleep(500)
        ie.Document.getElementById("comment").value := "This is a comment"
        MsgBox("Text area filled!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example7_FormSubmit() {
    MsgBox("Example 7: Form Submit")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        ie.Document.write("<form id='form1'><input type='text'></form>")
        Sleep(500)
        ; ie.Document.getElementById("form1").submit()
        MsgBox("Form ready to submit")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

ShowMenu() {
    menu := "
    (
    IE COM - Forms

    1. Fill Text Box
    2. Check Box
    3. Radio Button
    4. Select Dropdown
    5. Click Button
    6. Text Area
    7. Form Submit

    0. Exit
    )"
    choice := InputBox(menu, "Form Examples", "w300 h400").Value
    switch choice {
        case "1": Example1_FillTextBox()
        case "2": Example2_CheckBox()
        case "3": Example3_RadioButton()
        case "4": Example4_SelectDropdown()
        case "5": Example5_ClickButton()
        case "6": Example6_TextArea()
        case "7": Example7_FormSubmit()
        case "0": return
        default: MsgBox("Invalid!")
    }
    if MsgBox("Run another?", "Continue?", "YesNo") = "Yes"
        ShowMenu()
}
ShowMenu()
