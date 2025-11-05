#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; Advanced GUI Example: Dynamic Control Creation and Removal
; Demonstrates: Dynamic control creation, arrays of controls, control removal

myGui := Gui()
myGui.Title := "Dynamic Form Builder"

myGui.Add("Text", "x10 y10", "Add form fields dynamically:")
myGui.Add("Button", "x10 y35 w150", "Add Text Field").OnEvent("Click", AddTextField)
myGui.Add("Button", "x170 y35 w150", "Add Checkbox").OnEvent("Click", AddCheckbox)
myGui.Add("Button", "x330 y35 w150", "Add Dropdown").OnEvent("Click", AddDropdown)

myGui.Add("GroupBox", "x10 y70 w470 h300", "Form Fields")

myGui.Add("Button", "x10 y380 w100", "Submit").OnEvent("Click", SubmitForm)
myGui.Add("Button", "x120 y380 w100", "Clear All").OnEvent("Click", ClearAll)

myGui.Show("w490 h420")

global controls := []
global yPos := 95
global fieldCount := 0

AddTextField(*) {
    global controls, yPos, fieldCount

    if (yPos > 340)
        return MsgBox("Form is full!", "Warning")

    fieldCount++
    labelText := "Field " fieldCount ":"

    ; Create label
    label := myGui.Add("Text", "x20 y" yPos, labelText)

    ; Create edit control
    edit := myGui.Add("Edit", "x100 y" (yPos - 3) " w250")

    ; Create remove button
    removeBtn := myGui.Add("Button", "x360 y" (yPos - 3) " w100", "Remove")
    removeIdx := controls.Length + 1
    removeBtn.OnEvent("Click", (*) => RemoveField(removeIdx))

    ; Store controls
    controls.Push({type: "text", label: label, control: edit, button: removeBtn})

    yPos += 35
}

AddCheckbox(*) {
    global controls, yPos, fieldCount

    if (yPos > 340)
        return MsgBox("Form is full!", "Warning")

    fieldCount++

    ; Create checkbox
    checkbox := myGui.Add("Checkbox", "x20 y" yPos, "Option " fieldCount)

    ; Create remove button
    removeBtn := myGui.Add("Button", "x360 y" (yPos - 3) " w100", "Remove")
    removeIdx := controls.Length + 1
    removeBtn.OnEvent("Click", (*) => RemoveField(removeIdx))

    ; Store controls
    controls.Push({type: "checkbox", label: "", control: checkbox, button: removeBtn})

    yPos += 35
}

AddDropdown(*) {
    global controls, yPos, fieldCount

    if (yPos > 340)
        return MsgBox("Form is full!", "Warning")

    fieldCount++
    labelText := "Select " fieldCount ":"

    ; Create label
    label := myGui.Add("Text", "x20 y" yPos, labelText)

    ; Create dropdown
    ddl := myGui.Add("DropDownList", "x100 y" (yPos - 3) " w250", ["Option 1", "Option 2", "Option 3"])
    ddl.Choose(1)

    ; Create remove button
    removeBtn := myGui.Add("Button", "x360 y" (yPos - 3) " w100", "Remove")
    removeIdx := controls.Length + 1
    removeBtn.OnEvent("Click", (*) => RemoveField(removeIdx))

    ; Store controls
    controls.Push({type: "dropdown", label: label, control: ddl, button: removeBtn})

    yPos += 35
}

RemoveField(index) {
    global controls, yPos

    if (index < 1 || index > controls.Length)
        return

    field := controls[index]

    ; Destroy controls
    if (field.label != "")
        field.label.Destroy()
    field.control.Destroy()
    field.button.Destroy()

    ; Remove from array
    controls.RemoveAt(index)

    ; Rebuild form layout
    RebuildLayout()
}

ClearAll(*) {
    global controls, yPos, fieldCount

    ; Destroy all controls
    for field in controls {
        if (field.label != "")
            field.label.Destroy()
        field.control.Destroy()
        field.button.Destroy()
    }

    controls := []
    yPos := 95
    fieldCount := 0
}

RebuildLayout() {
    global controls, yPos

    yPos := 95

    for field in controls {
        ; Reposition label
        if (field.label != "")
            field.label.Move(20, yPos)

        ; Reposition control
        field.control.Move(100, yPos - 3)

        ; Reposition button
        field.button.Move(360, yPos - 3)

        yPos += 35
    }
}

SubmitForm(*) {
    global controls

    if (controls.Length = 0)
        return MsgBox("No fields to submit!", "Warning")

    output := "Form Data:`n`n"

    for i, field in controls {
        output .= "Field " i " (" field.type "): "

        Switch field.type {
            case "text":
                output .= field.control.Value
            case "checkbox":
                output .= field.control.Value ? "Checked" : "Unchecked"
            case "dropdown":
                output .= field.control.Text
        }

        output .= "`n"
    }

    MsgBox(output, "Form Submitted")
}
