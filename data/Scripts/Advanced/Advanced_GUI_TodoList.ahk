#Requires AutoHotkey v2.0
#SingleInstance Force
; Advanced GUI Example: Todo List Manager
; Demonstrates: ListView, button events, dynamic row manipulation, data persistence

todoGui := Gui()
todoGui.Title := "Todo List Manager"
todoGui.Add("Text", "x10 y10", "Task:")
taskInput := todoGui.Add("Edit", "x50 y10 w300")
addBtn := todoGui.Add("Button", "x360 y8 w80", "Add Task").OnEvent("Click", AddTask)

; ListView with columns
LV := todoGui.Add("ListView", "x10 y40 w440 h300 Checked", ["Status", "Task", "Added"])

; Action buttons
todoGui.Add("Button", "x10 y350 w100", "Mark Done").OnEvent("Click", MarkDone)
todoGui.Add("Button", "x120 y350 w100", "Delete").OnEvent("Click", DeleteTask)
todoGui.Add("Button", "x230 y350 w100", "Clear All").OnEvent("Click", ClearAll)
todoGui.Add("Button", "x340 y350 w110", "Export").OnEvent("Click", ExportTasks)

todoGui.OnEvent("Close", SaveAndExit)
todoGui.Show("w460 h390")

; Load saved tasks if they exist
LoadTasks()

AddTask(*) {
    global taskInput, LV
    task := Trim(taskInput.Value)
    if (task = "")
        return

    timestamp := FormatTime(, "yyyy-MM-dd HH:mm")
    LV.Add(, "Pending", task, timestamp)
    taskInput.Value := ""
    LV.ModifyCol()  ; Auto-size columns
}

MarkDone(*) {
    global LV
    row := LV.GetNext()
    if (row) {
        LV.Modify(row, , "Done")
        LV.Modify(row, "Check")
    }
}

DeleteTask(*) {
    global LV
    while (row := LV.GetNext()) {
        LV.Delete(row)
    }
}

ClearAll(*) {
    global LV
    result := MsgBox("Delete all tasks?", "Confirm", "YesNo Icon?")
    if (result = "Yes")
        LV.Delete()
}

ExportTasks(*) {
    global LV
    output := "Todo List Export - " FormatTime(, "yyyy-MM-dd HH:mm:ss") "`n`n"

    Loop LV.GetCount() {
        status := LV.GetText(A_Index, 1)
        task := LV.GetText(A_Index, 2)
        added := LV.GetText(A_Index, 3)
        output .= "[" status "] " task " (Added: " added ")`n"
    }

    filename := "TodoList_" FormatTime(, "yyyyMMdd_HHmmss") ".txt"
    FileAppend(output, filename)
    MsgBox("Exported to: " filename, "Success")
}

LoadTasks() {
    global LV
    if !FileExist("todolist.dat")
        return

    contents := FileRead("todolist.dat")
    Loop Parse, contents, "`n", "`r" {
        if (A_LoopField = "")
            continue
        parts := StrSplit(A_LoopField, "|")
        if (parts.Length >= 3)
            LV.Add(, parts[1], parts[2], parts[3])
    }
    LV.ModifyCol()
}

SaveAndExit(*) {
    global LV
    output := ""
    Loop LV.GetCount() {
        status := LV.GetText(A_Index, 1)
        task := LV.GetText(A_Index, 2)
        added := LV.GetText(A_Index, 3)
        output .= status "|" task "|" added "`n"
    }

    if (output != "")
        FileDelete("todolist.dat")
    FileAppend(output, "todolist.dat")

    ExitApp
}
