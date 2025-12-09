#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* GUI Control Patterns
*
* Demonstrates common GUI control patterns: Edit, Button, ListBox, CheckBox,
* with proper event handling and data management using Maps.
*
* Source: AHK_Notes/Concepts/GUI_Controls_and_Patterns.md
*/

app := TaskManagerApp()
app.Show()

/**
* TaskManagerApp - Simple task manager with GUI controls
*/
class TaskManagerApp {
    gui := ""
    controls := Map()  ; Store control references
    tasks := []        ; Task list

    __New() {
        ; Create GUI
        this.gui := Gui("+Resize", "Task Manager")
        this.gui.SetFont("s10")

        ; Add controls
        this.gui.Add("Text", "w400", "Task Description:")
        this.controls["taskInput"] := this.gui.Add("Edit", "w400")

        ; Add Task button
        this.controls["addBtn"] := this.gui.Add("Button", "w195", "Add Task")
        this.controls["addBtn"].OnEvent("Click", ObjBindMethod(this, "OnAddTask"))

        ; Remove Task button
        this.controls["removeBtn"] := this.gui.Add("Button", "x+10 w195", "Remove Selected")
        this.controls["removeBtn"].OnEvent("Click", ObjBindMethod(this, "OnRemoveTask"))

        ; Task list
        this.gui.Add("Text", "xm y+10 w400", "Tasks:")
        this.controls["taskList"] := this.gui.Add("ListBox", "w400 h200")

        ; Status bar
        this.controls["status"] := this.gui.Add("Text", "w400 y+10", "Ready")

        ; Window events
        this.gui.OnEvent("Close", ObjBindMethod(this, "OnClose"))
        this.gui.OnEvent("Escape", ObjBindMethod(this, "OnClose"))
    }

    /**
    * Add task to list
    */
    OnAddTask(ctrl, *) {
        taskText := this.controls["taskInput"].Value

        if (Trim(taskText) == "") {
            MsgBox("Please enter a task description", "Error", "Icon!")
            return
        }

        ; Add to tasks array
        this.tasks.Push(taskText)

        ; Update ListBox
        this.UpdateTaskList()

        ; Clear input
        this.controls["taskInput"].Value := ""

        ; Update status
        this.controls["status"].Value := "Added: " taskText
    }

    /**
    * Remove selected task
    */
    OnRemoveTask(ctrl, *) {
        selectedIndex := this.controls["taskList"].Value

        if (selectedIndex == 0) {
            MsgBox("Please select a task to remove", "Error", "Icon!")
            return
        }

        removedTask := this.tasks[selectedIndex]
        this.tasks.RemoveAt(selectedIndex)

        ; Update ListBox
        this.UpdateTaskList()

        ; Update status
        this.controls["status"].Value := "Removed: " removedTask
    }

    /**
    * Update task list display
    */
    UpdateTaskList() {
        ; Clear ListBox
        this.controls["taskList"].Delete()

        ; Add all tasks
        for task in this.tasks {
            this.controls["taskList"].Add([task])
        }

        ; Update status with count
        count := this.tasks.Length
        this.controls["status"].Value := "Total tasks: " count
    }

    /**
    * Handle window close
    */
    OnClose(*) {
        if (this.tasks.Length > 0) {
            result := MsgBox("You have " this.tasks.Length " tasks. Really quit?",
            "Confirm Exit", "YesNo Icon?")
            if (result == "No")
            return
        }
        this.gui.Destroy()
    }

    /**
    * Show GUI
    */
    Show() {
        this.gui.Show()
    }
}

/*
* Key Concepts:
*
* 1. Control Storage Pattern:
*    controls := Map()
*    controls["name"] := gui.Add(...)
*    Access controls by name
*
* 2. Event Binding:
*    btn.OnEvent("Click", ObjBindMethod(this, "Handler"))
*    ObjBindMethod preserves 'this' context
*
* 3. Common Controls:
*    Edit - Text input
*    Button - Clickable action
*    ListBox - Selectable list
*    Text - Static label
*
* 4. Control Methods:
*    ctrl.Value - Get/set value
*    listBox.Add([items]) - Add items
*    listBox.Delete() - Clear items
*
* 5. GUI Events:
*    Close - Window closing
*    Escape - ESC key
*    Click - Button click
*
* 6. Data Management:
*    tasks := []  ; Data model
*    Separate data from display
*    Update display from data
*
* 7. Input Validation:
*    if (Trim(text) == "")
*        ; Show error
*    Validate before processing
*
* 8. Confirmation Dialogs:
*    MsgBox("Message", "Title", "YesNo Icon?")
*    result == "Yes" or "No"
*
* 9. Best Practices:
*    ✅ Use Map for controls
*    ✅ Bind events with ObjBindMethod
*    ✅ Validate user input
*    ✅ Separate data from UI
*    ✅ Provide feedback (status bar)
*    ✅ Confirm destructive actions
*
* 10. GUI Structure:
*     __New() {
    *         Create GUI
    *         Add controls
    *         Bind events
    *     }
    *     Event handlers
    *     Helper methods
    */
