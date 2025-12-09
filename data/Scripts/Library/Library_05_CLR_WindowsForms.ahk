#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* CLR - Windows Forms GUI Application
*
* Demonstrates creating a rich Windows Forms GUI with buttons, textboxes,
* listboxes, and event handling using .NET Framework.
*
* Library: https://github.com/Lexikos/CLR.ahk
*/

MsgBox("CLR - Windows Forms Example`n`n"
. "Demonstrates rich GUI with .NET`n"
. "Requires: CLR.ahk and .NET Framework 4.0+", , "T3")

/*
; Uncomment to run (requires CLR.ahk):

#Include <CLR>

; Initialize CLR
CLR_Start("v4.0.30319")

; Load Windows Forms assembly
asm := CLR_LoadLibrary("System.Windows.Forms")
Drawing := CLR_LoadLibrary("System.Drawing")

; Create Form
Form := CLR_CreateObject(asm, "System.Windows.Forms.Form")
Form.Text := "Task Manager - .NET Forms"
Form.Width := 500
Form.Height := 400
Form.StartPosition := 1  ; CenterScreen

; Create Label
Label := CLR_CreateObject(asm, "System.Windows.Forms.Label")
Label.Text := "Task Description:"
Label.Location := CLR_CreateObject(Drawing, "System.Drawing.Point", 10, 10)
Label.AutoSize := true
Form.Controls.Add(Label)

; Create TextBox
TextBox := CLR_CreateObject(asm, "System.Windows.Forms.TextBox")
TextBox.Location := CLR_CreateObject(Drawing, "System.Drawing.Point", 10, 35)
TextBox.Width := 360
Form.Controls.Add(TextBox)

; Create Add Button
AddButton := CLR_CreateObject(asm, "System.Windows.Forms.Button")
AddButton.Text := "Add Task"
AddButton.Location := CLR_CreateObject(Drawing, "System.Drawing.Point", 380, 33)
AddButton.Width := 90
Form.Controls.Add(AddButton)

; Create ListBox
ListBox := CLR_CreateObject(asm, "System.Windows.Forms.ListBox")
ListBox.Location := CLR_CreateObject(Drawing, "System.Drawing.Point", 10, 70)
ListBox.Width := 460
ListBox.Height := 200
Form.Controls.Add(ListBox)

; Create Remove Button
RemoveButton := CLR_CreateObject(asm, "System.Windows.Forms.Button")
RemoveButton.Text := "Remove Selected"
RemoveButton.Location := CLR_CreateObject(Drawing, "System.Drawing.Point", 10, 280)
RemoveButton.Width := 120
Form.Controls.Add(RemoveButton)

; Create Clear Button
ClearButton := CLR_CreateObject(asm, "System.Windows.Forms.Button")
ClearButton.Text := "Clear All"
ClearButton.Location := CLR_CreateObject(Drawing, "System.Drawing.Point", 140, 280)
ClearButton.Width := 100
Form.Controls.Add(ClearButton)

; Create Status Label
StatusLabel := CLR_CreateObject(asm, "System.Windows.Forms.Label")
StatusLabel.Text := "Ready"
StatusLabel.Location := CLR_CreateObject(Drawing, "System.Drawing.Point", 10, 320)
StatusLabel.Width := 460
StatusLabel.AutoSize := false
Form.Controls.Add(StatusLabel)

; Add Button Click Event
AddButton.Add_Click(AddTask)

; Remove Button Click Event
RemoveButton.Add_Click(RemoveTask)

; Clear Button Click Event
ClearButton.Add_Click(ClearTasks)

; Event Handlers
AddTask(sender, e) {
    global TextBox, ListBox, StatusLabel
    text := TextBox.Text
    if (text != "") {
        ListBox.Items.Add(text)
        TextBox.Text := ""
        StatusLabel.Text := "Added: " text
    }
}

RemoveTask(sender, e) {
    global ListBox, StatusLabel
    if (ListBox.SelectedIndex >= 0) {
        item := ListBox.SelectedItem.ToString()
        ListBox.Items.RemoveAt(ListBox.SelectedIndex)
        StatusLabel.Text := "Removed: " item
    }
}

ClearTasks(sender, e) {
    global ListBox, StatusLabel
    count := ListBox.Items.Count
    ListBox.Items.Clear()
    StatusLabel.Text := "Cleared " count " tasks"
}

; Show the form
Form.ShowDialog()
*/

/*
* Key Concepts:
*
* 1. Loading Windows Forms:
*    asm := CLR_LoadLibrary("System.Windows.Forms")
*    Drawing := CLR_LoadLibrary("System.Drawing")
*
* 2. Creating Controls:
*    Form := CLR_CreateObject(asm, "System.Windows.Forms.Form")
*    Button := CLR_CreateObject(asm, "System.Windows.Forms.Button")
*    TextBox := CLR_CreateObject(asm, "System.Windows.Forms.TextBox")
*
* 3. Setting Properties:
*    control.Text := "Label Text"
*    control.Width := 300
*    control.Height := 200
*
* 4. Point and Size:
*    point := CLR_CreateObject(Drawing, "System.Drawing.Point", x, y)
*    size := CLR_CreateObject(Drawing, "System.Drawing.Size", w, h)
*
* 5. Adding to Form:
*    Form.Controls.Add(control)
*    Adds control to form's collection
*
* 6. Event Handling:
*    Button.Add_Click(HandlerFunction)
*    HandlerFunction(sender, e) { ... }
*
* 7. Common Controls:
*    Form - Main window
*    Button - Clickable button
*    TextBox - Text input
*    Label - Static text
*    ListBox - Item list
*    ComboBox - Dropdown
*    CheckBox - Checkbox
*    RadioButton - Radio button
*    Panel - Container
*    MenuStrip - Menu bar
*
* 8. Form Properties:
*    StartPosition: 0=Manual, 1=CenterScreen
*    FormBorderStyle: 0=None, 3=FixedDialog
*    MaximizeBox: true/false
*    MinimizeBox: true/false
*
* 9. Advantages:
*    ✅ Rich controls (TreeView, DataGridView)
*    ✅ Native Windows look
*    ✅ Complex layouts
*    ✅ MDI applications
*    ✅ Custom drawing
*
* 10. Use Cases:
*     ✅ Database front-ends
*     ✅ Configuration utilities
*     ✅ Admin tools
*     ✅ Data entry forms
*     ✅ Complex UIs
*
* 11. Best Practices:
*     ✅ Use global for event handlers
*     ✅ Cache control references
*     ✅ Dispose resources
*     ✅ Handle exceptions
*     ✅ Use appropriate control types
*/
