#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; Advanced Data Structure Example: Stack (LIFO) with Applications
; Demonstrates: Stack operations, undo/redo functionality, expression evaluation

; Stack class implementation
class Stack {
    __New() {
        this.items := []
    }

    ; Add item to top of stack
    Push(item) {
        this.items.Push(item)
    }

    ; Remove and return top item
    Pop() {
        if (this.IsEmpty())
            throw Error("Stack is empty")
        return this.items.Pop()
    }

    ; View top item without removing
    Peek() {
        if (this.IsEmpty())
            throw Error("Stack is empty")
        return this.items[this.items.Length]
    }

    ; Check if stack is empty
    IsEmpty() {
        return this.items.Length = 0
    }

    ; Get stack size
    Size() {
        return this.items.Length
    }

    ; Clear all items
    Clear() {
        this.items := []
    }

    ; Get all items (top to bottom)
    ToArray() {
        arr := []
        Loop this.items.Length {
            arr.Push(this.items[this.items.Length - A_Index + 1])
        }
        return arr
    }
}

; Undo/Redo manager using stacks
class UndoRedoManager {
    __New() {
        this.undoStack := Stack()
        this.redoStack := Stack()
    }

    ; Execute an action and add to undo stack
    Do(action, data) {
        this.undoStack.Push({action: action, data: data})
        this.redoStack.Clear()  ; Clear redo stack on new action
    }

    ; Undo last action
    Undo() {
        if (this.undoStack.IsEmpty())
            throw Error("Nothing to undo")

        item := this.undoStack.Pop()
        this.redoStack.Push(item)
        return item
    }

    ; Redo last undone action
    Redo() {
        if (this.redoStack.IsEmpty())
            throw Error("Nothing to redo")

        item := this.redoStack.Pop()
        this.undoStack.Push(item)
        return item
    }

    ; Check if undo is available
    CanUndo() {
        return !this.undoStack.IsEmpty()
    }

    ; Check if redo is available
    CanRedo() {
        return !this.redoStack.IsEmpty()
    }
}

; Create GUI
Persistent

stackGui := Gui()
stackGui.Title := "Stack Data Structure - Text Editor with Undo/Redo"

; Toolbar
stackGui.Add("Button", "x10 y10 w80", "Undo (^Z)").OnEvent("Click", UndoAction)
stackGui.Add("Button", "x100 y10 w80", "Redo (^Y)").OnEvent("Click", RedoAction)
stackGui.Add("Button", "x190 y10 w80", "Clear All").OnEvent("Click", ClearAll)

; Text editor
stackGui.Add("Text", "x10 y45", "Text Editor:")
textEditor := stackGui.Add("Edit", "x10 y65 w560 h200 Multi")
textEditor.OnEvent("Change", TextChanged)

; Action buttons
stackGui.Add("Text", "x10 y275", "Quick Actions:")
stackGui.Add("Button", "x10 y295 w120", "Insert Timestamp").OnEvent("Click", InsertTimestamp)
stackGui.Add("Button", "x140 y295 w120", "Insert Separator").OnEvent("Click", InsertSeparator)
stackGui.Add("Button", "x270 y295 w120", "Make Uppercase").OnEvent("Click", MakeUppercase)
stackGui.Add("Button", "x400 y295 w120", "Make Lowercase").OnEvent("Click", MakeLowercase)

; Undo stack display
stackGui.Add("Text", "x10 y335", "Undo Stack (most recent on top):")
undoList := stackGui.Add("ListView", "x10 y355 w270 h150", ["Action", "Preview"])

; Redo stack display
stackGui.Add("Text", "x290 y335", "Redo Stack:")
redoList := stackGui.Add("ListView", "x290 y355 w280 h150", ["Action", "Preview"])

stackGui.Show("w580 h520")

; Global variables
global undoManager := UndoRedoManager()
global previousText := ""
global isUpdating := false

; Hotkeys
^z::UndoAction()
^y::RedoAction()

TextChanged(*) {
    global previousText, isUpdating

    if (isUpdating)
        return

    currentText := textEditor.Value

    if (currentText != previousText) {
        undoManager.Do("Edit", previousText)
        previousText := currentText
        UpdateStackDisplay()
    }
}

UndoAction(*) {
    global previousText, isUpdating

    try {
        item := undoManager.Undo()

        isUpdating := true
        textEditor.Value := item.data
        previousText := item.data
        isUpdating := false

        UpdateStackDisplay()
    } catch Error as err {
        ; Silently ignore if nothing to undo
    }
}

RedoAction(*) {
    global previousText, isUpdating

    try {
        item := undoManager.Redo()

        isUpdating := true
        textEditor.Value := item.data
        previousText := item.data
        isUpdating := false

        UpdateStackDisplay()
    } catch Error as err {
        ; Silently ignore if nothing to redo
    }
}

ClearAll(*) {
    global undoManager, previousText, isUpdating

    result := MsgBox("Clear all text and history?", "Confirm", "YesNo")

    if (result = "Yes") {
        undoManager := UndoRedoManager()

        isUpdating := true
        textEditor.Value := ""
        previousText := ""
        isUpdating := false

        UpdateStackDisplay()
    }
}

InsertTimestamp(*) {
    global isUpdating

    timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")

    isUpdating := true
    currentText := textEditor.Value
    textEditor.Value := currentText . "`n" . timestamp
    isUpdating := false

    undoManager.Do("Insert Timestamp", currentText)
    previousText := textEditor.Value
    UpdateStackDisplay()
}

InsertSeparator(*) {
    global isUpdating

    separator := StrReplace(Format("{:60}", ""), " ", "-")

    isUpdating := true
    currentText := textEditor.Value
    textEditor.Value := currentText . "`n" . separator . "`n"
    isUpdating := false

    undoManager.Do("Insert Separator", currentText)
    previousText := textEditor.Value
    UpdateStackDisplay()
}

MakeUppercase(*) {
    global isUpdating

    isUpdating := true
    currentText := textEditor.Value
    textEditor.Value := StrUpper(currentText)
    isUpdating := false

    undoManager.Do("Make Uppercase", currentText)
    previousText := textEditor.Value
    UpdateStackDisplay()
}

MakeLowercase(*) {
    global isUpdating

    isUpdating := true
    currentText := textEditor.Value
    textEditor.Value := StrLower(currentText)
    isUpdating := false

    undoManager.Do("Make Lowercase", currentText)
    previousText := textEditor.Value
    UpdateStackDisplay()
}

UpdateStackDisplay() {
    ; Update undo stack display
    undoList.Delete()
    undoItems := undoManager.undoStack.ToArray()
    for item in undoItems {
        preview := SubStr(StrReplace(item.data, "`n", " "), 1, 30)
        if (StrLen(item.data) > 30)
            preview .= "..."
        undoList.Add(, item.action, preview)
    }
    undoList.ModifyCol()

    ; Update redo stack display
    redoList.Delete()
    redoItems := undoManager.redoStack.ToArray()
    for item in redoItems {
        preview := SubStr(StrReplace(item.data, "`n", " "), 1, 30)
        if (StrLen(item.data) > 30)
            preview .= "..."
        redoList.Add(, item.action, preview)
    }
    redoList.ModifyCol()
}
